import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:mpeg_codec/mpeg_codec.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tunes/models/filters/filters.dart';
import 'package:tunes/providers/providers.dart';
import 'package:watcher/watcher.dart';

part 'media_query.g.dart';

@collection
class Song {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;

  @Index(type: IndexType.value)
  late String artist;

  @Index(type: IndexType.value)
  late String album;

  @Index(type: IndexType.value)
  late String genre;

  @Index(unique: true, type: IndexType.value)
  late String filePath;

  @Index(type: IndexType.value)
  late int lastModified;

  @Index(type: IndexType.value)
  late int duration;

  @Index(type: IndexType.value)
  late int size;

  String? thumbnailPath;
  String? thumbnailMiniPath;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.filePath,
    required this.lastModified,
    required this.duration,
    required this.size,
    this.thumbnailPath,
    this.thumbnailMiniPath,
  });
}

@collection
class Playlist {
  Id id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.value)
  late String name;

  final songs = IsarLinks<Song>();
}

const id3Mimes = [
  "audio/mpeg", // Standard MIME type for MP3 files.
  "audio/x-mpeg", // An older MIME type for MP3 files.
  "audio/x-mp3", // Another variant for MP3 files.
  "audio/mpeg3", // Sometimes used for MP3 files.
  "audio/x-mpeg3", // Another variant for MP3 files.
  "audio/mpg", // Occasionally used for MP3 files.
  "audio/x-mpg", // Another variant for MP3 files.
  "audio/mp3", // Commonly used for MP3 files.
  "audio/x-mp3", // Another variant for MP3 files.
];

const mp4Mimes = [
  "video/mp4", // Standard MIME type for MP4 video files.
  "audio/mp4", // Used for MP4 audio files.
  "application/mp4", // Used for MP4 files that contain only metadata or subtitles.
  "video/x-m4v", // Sometimes used for MP4 video files, especially on Apple devices.
  "audio/x-m4a", // Used for MP4 audio files, particularly on Apple devices.
  "video/quicktime", // Used for QuickTime files, which can also contain MP4 content.
];

const supportedMimes = [...id3Mimes, ...mp4Mimes];

bool shouldInclude(String filePath, Set<PathFilter> filters) {
  PathFilter? mostSpecificFilter;
  for (var filter in filters) {
    if (filePath.startsWith(filter.path) && filter.enabled) {
      if (mostSpecificFilter == null ||
          filter.path.length > mostSpecificFilter.path.length) {
        mostSpecificFilter = filter;
      }
    }
  }
  return mostSpecificFilter?.include ?? true;
}

enum SongsSortType {
  title,
  artist,
  album,
  genre,
  modified,
  duration,
  size,
}

enum SongQueryType {
  all,
  artist,
  album,
  genre,
  playlist,
}

class AudioQuery {
  late Isar _isar;
  late Directory _thumbnailDirectory;
  final Logger _logger = Logger();
  final List<StreamSubscription<WatchEvent>> _watchers = [];

  final _indexingProgressController = StreamController<int>.broadcast();
  final _indexingErrorsController = StreamController<List<String>>.broadcast();

  Stream<int> get indexingProgress => _indexingProgressController.stream;
  Stream<List<String>> get indexingErrors => _indexingErrorsController.stream;
  IsarCollection<Song> get songs => _isar.songs;

  AudioQuery(Isar isar, Directory thumbnailDirectory) {
    _isar = isar;
    _thumbnailDirectory = thumbnailDirectory;
  }

  Future<void> index(Set<PathFilter> filterPaths) async {
    _logger.d("Initialized indexing");
    await _indexMedia(filterPaths);
    _setupWatchers(filterPaths);
  }

  Future<void> _indexMedia(Set<PathFilter> paths) async {
    _logger.d("Now Indexing");
    final receivePort = ReceivePort();

    // Get existing file paths and last modified times
    final existingFiles = await _getExistingFilesInfo();
    _logger.d("Got existing files");

    await Isolate.spawn(_indexMediaIsolate, [
      paths,
      existingFiles,
      receivePort.sendPort,
    ]);

    List<Metadata> batch = [];
    int processedFiles = 0;

    await for (var message in receivePort) {
      if (message is Metadata) {
        batch.add(message);
        if (batch.length >= 100) {
          await _addOrUpdateSongs(batch);
          processedFiles += batch.length;
          _indexingProgressController.add(processedFiles);
          batch.clear();
        }
      } else if (message == 'DONE') {
        if (batch.isNotEmpty) {
          await _addOrUpdateSongs(batch);
          processedFiles += batch.length;
          _indexingProgressController.add(processedFiles);
        }
        break;
      }
    }

    _indexingProgressController.close();
  }

  Future<Map<String, int>> _getExistingFilesInfo() async {
    return _isar.txn(() async {
      try {
        final songs = await _isar.songs.where().findAll();
        return {
          for (var element in songs) element.filePath: element.lastModified
        };
      } catch (e) {
        _logger.e(e);
        return {};
      }
    });
  }

  static void _indexMediaIsolate(List<dynamic> args) async {
    Set<PathFilter> filterPaths = args[0];
    Map<String, int> existingFiles = args[1];
    SendPort sendPort = args[2];

    for (final filterPath in filterPaths) {
      if (filterPath.enabled && filterPath.include) {
        final directory = Directory(filterPath.path);
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File && shouldInclude(entity.path, filterPaths)) {
            final lastModified = await entity.lastModified();
            final lastModifiedMillis = lastModified.millisecondsSinceEpoch;

            // Check if the file has been modified since last indexing
            if (!existingFiles.containsKey(entity.path) ||
                existingFiles[entity.path]! < lastModifiedMillis) {
              final metadata = await _extractMetadata(entity.path);
              if (metadata != null) {
                metadata.set('lastModified', lastModifiedMillis);
                sendPort.send(metadata);
              }
            }

            // Remove the file from existingFiles to track deletions
            existingFiles.remove(entity.path);
          }
        }
      }
    }

    // Handle deleted files
    for (final deletedFilePath in existingFiles.keys) {
      final metadata = Metadata();
      metadata.set('filePath', deletedFilePath);
      metadata.set('deleted', true);
      sendPort.send(metadata);
    }

    sendPort.send('DONE');
  }

  Future<void> _processFileWithRetry(
    String filePath, {
    int maxRetries = 3,
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final metadata = await _extractMetadata(filePath);
        if (metadata != null) {
          final lastModified = await File(filePath)
              .lastModified()
              .then((date) => date.millisecondsSinceEpoch);
          metadata.set('lastModified', lastModified);
          await _addOrUpdateSong(metadata);
          break;
        }
      } catch (e) {
        if (i == maxRetries - 1) {
          // Log the error or notify the user
          _indexingErrorsController.add([
            'Failed to process file after $maxRetries attempts: $filePath',
          ]);
        } else {
          await Future.delayed(
            Duration(seconds: 1 << i),
          ); // Exponential backoff
        }
      }
    }
  }

  static Future<Metadata?> _extractMetadata(String filePath) async {
    final mimeType = lookupMimeType(filePath);
    final handler = createCodecHandler(filePath);

    if (handler == null) return null;

    final metadata = handler.metadata;
    metadata.set(
      'title',
      metadata.get('title') ?? path.basenameWithoutExtension(filePath),
    );
    metadata.set('artist', metadata.get('artist') ?? 'Unknown Artist');
    metadata.set('album', metadata.get('album') ?? 'Unknown Album');
    metadata.set('genre', metadata.get('genre') ?? 'Unknown Genre');
    return metadata;
  }

  static CodecHandler? createCodecHandler(
    String filePath,
  ) {
    final mimeType = lookupMimeType(filePath);
    if (id3Mimes.contains(mimeType)) {
      return ID3Handler(filePath);
    } else if (mp4Mimes.contains(mimeType)) {
      return MP4Handler(filePath);
    }

    return null;
  }

  static String? _ensureString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join('');
    return value.toString();
  }

  Future<void> _addOrUpdateSong(Metadata metadata) async {
    await _isar.writeTxn(() async {
      final thumbnailPaths = await _saveThumbnail(metadata);

      Song? existingSong = await _isar.songs
          .filter()
          .filePathEqualTo(metadata.get('filePath'))
          .findFirst();

      if (existingSong != null) {
        if (existingSong.lastModified != metadata.get('lastModified')) {
          existingSong
            ..title = _ensureString(metadata.get('title')) ?? existingSong.title
            ..artist =
                _ensureString(metadata.get('artist')) ?? existingSong.artist
            ..album = _ensureString(metadata.get('album')) ?? existingSong.album
            ..genre = _ensureString(metadata.get('genre')) ?? existingSong.genre
            ..lastModified = metadata.get('lastModified')
            ..duration = metadata.get('duration') ?? existingSong.duration
            ..size = metadata.get('size') ?? existingSong.size
            ..thumbnailPath =
                thumbnailPaths.original ?? existingSong.thumbnailPath
            ..thumbnailMiniPath =
                thumbnailPaths.mini ?? existingSong.thumbnailMiniPath;
          await _isar.songs.put(existingSong);
        }
      } else {
        Song newSong = Song(
          title: _ensureString(metadata.get('title')) ?? 'Unknown Title',
          artist: _ensureString(metadata.get('artist')) ?? 'Unknown Artist',
          album: _ensureString(metadata.get('album')) ?? 'Unknown Album',
          genre: _ensureString(metadata.get('genre')) ?? 'Unknown Genre',
          filePath: metadata.get('filePath'),
          lastModified: metadata.get('lastModified'),
          duration: metadata.get('duration') ?? 0,
          size: metadata.get('size') ?? 0,
          thumbnailPath: thumbnailPaths.original,
          thumbnailMiniPath: thumbnailPaths.mini,
        );
        await _isar.songs.put(newSong);
      }
    });
  }

  Future<void> _addOrUpdateSongs(
    List<Metadata> metadataList,
  ) async {
    await _isar.writeTxn(() async {
      for (var metadata in metadataList) {
        if (metadata.get('deleted') == true) {
          // Remove the song if it's been deleted
          await _isar.songs
              .filter()
              .filePathEqualTo(metadata.get('filePath'))
              .deleteAll();
        } else {
          final thumbnailPaths = await _saveThumbnail(metadata);

          Song? existingSong = await _isar.songs
              .filter()
              .filePathEqualTo(metadata.get('filePath'))
              .findFirst();

          if (existingSong != null) {
            existingSong
              ..title =
                  _ensureString(metadata.get('title')) ?? existingSong.title
              ..artist =
                  _ensureString(metadata.get('artist')) ?? existingSong.artist
              ..album =
                  _ensureString(metadata.get('album')) ?? existingSong.album
              ..genre =
                  _ensureString(metadata.get('genre')) ?? existingSong.genre
              ..lastModified = metadata.get('lastModified')
              ..duration = metadata.get('duration') ?? existingSong.duration
              ..size = metadata.get('size') ?? existingSong.size
              ..thumbnailPath =
                  thumbnailPaths.original ?? existingSong.thumbnailPath
              ..thumbnailMiniPath =
                  thumbnailPaths.mini ?? existingSong.thumbnailMiniPath;
            await _isar.songs.put(existingSong);
          } else {
            Song newSong = Song(
              title: _ensureString(metadata.get('title')) ?? 'Unknown Title',
              artist: _ensureString(metadata.get('artist')) ?? 'Unknown Artist',
              album: _ensureString(metadata.get('album')) ?? 'Unknown Album',
              genre: _ensureString(metadata.get('genre')) ?? 'Unknown Genre',
              filePath: metadata.get('filePath'),
              lastModified: metadata.get('lastModified'),
              duration: metadata.get('duration') ?? 0,
              size: metadata.get('size') ?? 0,
              thumbnailPath: thumbnailPaths.original,
              thumbnailMiniPath: thumbnailPaths.mini,
            );
            await _isar.songs.put(newSong);
          }
        }
      }
    });
  }

  void _setupWatchers(Set<PathFilter> filterPaths) {
    for (final filterPath in filterPaths) {
      if (filterPath.enabled && filterPath.include) {
        final watcher = DirectoryWatcher(filterPath.path);
        final subscription = watcher.events.listen((WatchEvent event) {
          if (event.type == ChangeType.ADD || event.type == ChangeType.MODIFY) {
            String? mimeType = lookupMimeType(event.path);
            if (supportedMimes.contains(mimeType) &&
                shouldInclude(event.path, filterPaths)) {
              _processFileWithRetry(event.path);
            }
          } else if (event.type == ChangeType.REMOVE) {
            _removeSong(event.path);
          }
        });
        _watchers.add(subscription);
      }
    }
  }

  Future<void> _removeSong(String filePath) async {
    await _isar.writeTxn(() async {
      await _isar.songs.filter().filePathEqualTo(filePath).deleteAll();
    });
  }

  Future<void> _cleanupNonExistentEntries() async {
    await _isar.writeTxn(() async {
      final allSongs = await _isar.songs.where().findAll();
      for (final song in allSongs) {
        if (!File(song.filePath).existsSync()) {
          await _isar.songs.delete(song.id);
        }
      }
    });
  }

  Future<({String? original, String? mini})> _saveThumbnail(
    Metadata metadata,
  ) async {
    Uint8List? imageData;
    if (metadata.get('cover') is Uint8List) {
      imageData = metadata.get('cover');
    } else if (metadata.get('picture') is Map<String, dynamic>) {
      imageData = metadata.get('picture')['data'];
    }

    if (imageData == null) {
      return (original: null, mini: null);
    }

    final hash = sha256.convert(imageData).toString();
    final originalPath = path.join(_thumbnailDirectory.path, '$hash.png');
    final miniPath = path.join(_thumbnailDirectory.path, '${hash}_mini.png');
    final originalFile = File(originalPath);
    final miniFile = File(miniPath);

    if (!await originalFile.exists() || !await miniFile.exists()) {
      // Decode the image
      img.Image? image = img.decodeImage(imageData);
      if (image == null) {
        _logger.e('Invalid image data');
        return (original: null, mini: null);
      }

      // Save original image
      if (!await originalFile.exists()) {
        await originalFile.writeAsBytes(imageData);
      }

      // Create and save mini version
      if (!await miniFile.exists()) {
        img.Image miniImage = img.copyResize(
          image,
          width: 75,
          height: 75,
        );
        await miniFile.writeAsBytes(
          Uint8List.fromList(img.encodePng(miniImage)),
        );
      }
    }

    return (original: originalPath, mini: miniPath);
  }

  Query<Song> querySongs({
    int? limit,
    int? offset,
    Sort sort = Sort.desc,
    SongsSortType sortType = SongsSortType.title,
    SongQueryType queryType = SongQueryType.all,
    String? query,
    String? searchQuery,
  }) {
    return _isar.songs.buildQuery(
      filter: FilterGroup.and(
        [
          if (searchQuery != null)
            FilterGroup.or(
              [
                'title',
                'artist',
                'album',
                'genre',
              ].map((e) {
                return FilterCondition.contains(
                  property: e,
                  value: searchQuery,
                  caseSensitive: false,
                );
              }).toList(),
            ),
          if (![
                SongQueryType.all,
                SongQueryType.playlist,
              ].contains(queryType) &&
              query != null)
            FilterCondition.contains(
              property: queryType.name,
              value: query,
              caseSensitive: false,
            ),
        ],
      ),
      sortBy: [
        SortProperty(
          property: sortType == SongsSortType.modified
              ? 'lastModified'
              : sortType.name,
          sort: sort,
        ),
      ],
      offset: offset,
      limit: limit,
    );
  }

  Future<int> songsCount({
    SongQueryType queryType = SongQueryType.all,
    String? query,
    String? searchQuery,
  }) {
    return querySongs(
      queryType: queryType,
      query: query,
      searchQuery: searchQuery,
    ).count();
  }

  Future<List<Song>> getSongs(
    int limit,
    int offset, {
    Sort sort = Sort.desc,
    SongsSortType sortType = SongsSortType.title,
    SongQueryType queryType = SongQueryType.all,
    String? query,
    String? searchQuery,
  }) {
    return querySongs(
      limit: limit,
      offset: offset,
      sort: sort,
      sortType: sortType,
      queryType: queryType,
      query: query,
      searchQuery: searchQuery,
    ).findAll();
  }

  Future<List<String>> getAlbums() async {
    return _isar.songs.where().albumProperty().findAll();
  }

  Future<List<String>> getArtists() async {
    return _isar.songs.where().artistProperty().findAll();
  }

  Future<List<String>> getGenres() async {
    return _isar.songs.where().genreProperty().findAll();
  }

  Future<void> dispose() async {
    for (var watcher in _watchers) {
      await watcher.cancel();
    }
    if (!_indexingProgressController.isClosed) {
      await _indexingProgressController.close();
    }
    if (!_indexingErrorsController.isClosed) {
      await _indexingErrorsController.close();
    }
  }
}

@Riverpod(keepAlive: true)
FutureOr<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    [SongSchema, PlaylistSchema],
    directory: dir.path,
    inspector: false,
  );
  ref.onDispose(() => isar.close());
  return isar;
}

@Riverpod(keepAlive: true)
FutureOr<Directory> thumbnailDirectory(ThumbnailDirectoryRef ref) async {
  final dir = await getApplicationSupportDirectory();

  final thumbnailDirectory = Directory(path.join(dir.path, '.thumbnails'));
  if (!await thumbnailDirectory.exists()) {
    await thumbnailDirectory.create(recursive: true);
  }
  return thumbnailDirectory;
}

@Riverpod(keepAlive: true)
AudioQuery mediaQuery(MediaQueryRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final dir = ref.watch(thumbnailDirectoryProvider).requireValue;
  final mq = AudioQuery(isar, dir);
  ref.onDispose(() => mq.dispose());
  return mq;
}

@Riverpod(keepAlive: true)
class IndexingController extends _$IndexingController {
  @override
  FutureOr<void> build() async {
    final mQuery = ref.watch(mediaQueryProvider);
    final filterConfigs = ref.watch(songsFilterConfigsProvider);

    return mQuery.index(filterConfigs.filterPaths);
  }
}

@riverpod
Stream<int> indexingProgress(IndexingProgressRef ref) {
  return ref.watch(mediaQueryProvider).indexingProgress;
}

@riverpod
Stream<void> songsWatcher(
  SongsWatcherRef ref, {
  SongQueryType queryType = SongQueryType.all,
  String? query,
  String? searchQuery,
}) {
  return ref
      .watch(mediaQueryProvider)
      .querySongs(
        queryType: queryType,
        query: query,
        searchQuery: searchQuery,
      )
      .watchLazy();
}

@riverpod
FutureOr<int> songsCount(
  SongsCountRef ref, {
  SongQueryType queryType = SongQueryType.all,
  String? query,
  String? searchQuery,
}) {
  ref.watch(songsWatcherProvider(
    queryType: queryType,
    query: query,
    searchQuery: searchQuery,
  ));
  return ref.watch(mediaQueryProvider).songsCount(
        queryType: queryType,
        query: query,
        searchQuery: searchQuery,
      );
}

@riverpod
class SongsQuery extends _$SongsQuery {
  @override
  FutureOr<List<Song>> build(
    int limit,
    int offset, {
    SongQueryType queryType = SongQueryType.all,
    String? query,
    String? searchQuery,
  }) {
    final songsSortOrder = ref.watch(
      songsSortOrderProvider(
        SongQueryType.all,
      ),
    );
    return ref.watch(mediaQueryProvider).getSongs(
          limit,
          offset,
          sort: songsSortOrder.orderType,
          sortType: songsSortOrder.sortType,
          queryType: queryType,
          query: query,
          searchQuery: searchQuery,
        );
  }
}
