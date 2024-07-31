import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mime/mime.dart';
import 'package:mpeg_codec/mpeg_codec.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_list_tile.dart';
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

  @Index(type: IndexType.value)
  late String filePath;

  @Index(type: IndexType.value)
  late int lastModified;

  String? thumbnailPath;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.filePath,
    required this.lastModified,
    this.thumbnailPath,
  });
}

@collection
class Playlist {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  final songs = IsarLinks<Song>();
}

const id3Mimes = [
  "audio/mpeg", // Standard MIME type for MP3 files.
  "audio/mp3", // Another common MIME type for MP3 files.
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

class MediaQuery {
  late Isar _isar;
  late Directory _thumbnailDirectory;
  final List<StreamSubscription<WatchEvent>> _watchers = [];
  final _indexingProgressController = StreamController<int>.broadcast();
  final _indexingErrorsController = StreamController<List<String>>.broadcast();

  Stream<int> get indexingProgress => _indexingProgressController.stream;
  Stream<List<String>> get indexingErrors => _indexingErrorsController.stream;

  Future<void> initialize(
    Set<PathFilter> filterPaths,
  ) async {
    final dir = await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [SongSchema],
      directory: dir.path,
    );

    _thumbnailDirectory = Directory(path.join(dir.path, '.thumbnails'));
    if (!await _thumbnailDirectory.exists()) {
      await _thumbnailDirectory.create(recursive: true);
    }

    await _indexMedia(filterPaths);
    _setupWatchers(filterPaths);
  }

  Future<void> _indexMedia(Set<PathFilter> paths) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_indexMediaIsolate, [paths, receivePort.sendPort]);

    List<Map<String, dynamic>> batch = [];
    int processedFiles = 0;

    await for (var message in receivePort) {
      if (message is Map<String, dynamic>) {
        batch.add(message);
        if (batch.length >= 100) {
          // Process in batches of 100
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

  static void _indexMediaIsolate(List<dynamic> args) async {
    Set<PathFilter> filterPaths = args.first;
    SendPort sendPort = args.last;

    for (final filterPath in filterPaths) {
      if (filterPath.enabled && filterPath.include) {
        final directory = Directory(filterPath.path);
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File && shouldInclude(entity.path, filterPaths)) {
            final metadata = await _extractMetadata(entity.path);
            if (metadata != null) {
              metadata['filePath'] = entity.path;
              metadata['lastModified'] = await entity
                  .lastModified()
                  .then((date) => date.millisecondsSinceEpoch);
              sendPort.send(metadata);
            }
          }
        }
      }
    }

    sendPort.send('DONE');
  }

  Future<void> _processFileWithRetry(
    String filePath, {
    int maxRetries = 3,
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        var metadata = await _extractMetadata(filePath);
        if (metadata != null) {
          metadata['filePath'] = filePath;
          metadata['lastModified'] = await File(filePath)
              .lastModified()
              .then((date) => date.millisecondsSinceEpoch);
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

  static Future<Map<String, dynamic>?> _extractMetadata(String filePath) async {
    final mimeType = lookupMimeType(filePath);
    final handler = _createMetadataHandler(filePath, mimeType);

    if (handler == null) return null;

    final metadata = handler.metadata;
    return {
      'title': metadata.get('title') ?? path.basenameWithoutExtension(filePath),
      'artist': metadata.get('artist') ?? 'Unknown Artist',
      'album': metadata.get('album') ?? 'Unknown Album',
      'genre': metadata.get('genre') ?? 'Unknown Genre',
      'filePath': filePath,
    };
  }

  static CodecHandler? _createMetadataHandler(
    String filePath,
    String? mimeType,
  ) {
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
    if (value is List) return value.join(', ');
    return value.toString();
  }

  Future<void> _addOrUpdateSong(Map<String, dynamic> metadata) async {
    await _isar.writeTxn(() async {
      String? thumbnailPath = await _saveThumbnail(metadata);

      Song? existingSong = await _isar.songs
          .filter()
          .filePathEqualTo(metadata['filePath'])
          .findFirst();

      if (existingSong != null) {
        if (existingSong.lastModified != metadata['lastModified']) {
          existingSong
            ..title = _ensureString(metadata['title']) ?? existingSong.title
            ..artist = _ensureString(metadata['artist']) ?? existingSong.artist
            ..album = _ensureString(metadata['album']) ?? existingSong.album
            ..genre = _ensureString(metadata['genre']) ?? existingSong.genre
            ..lastModified = metadata['lastModified']
            ..thumbnailPath = thumbnailPath ?? existingSong.thumbnailPath;
          await _isar.songs.put(existingSong);
        }
      } else {
        Song newSong = Song(
          title: _ensureString(metadata['title']) ?? 'Unknown Title',
          artist: _ensureString(metadata['artist']) ?? 'Unknown Artist',
          album: _ensureString(metadata['album']) ?? 'Unknown Album',
          genre: _ensureString(metadata['genre']) ?? 'Unknown Genre',
          filePath: metadata['filePath'],
          lastModified: metadata['lastModified'],
          thumbnailPath: thumbnailPath,
        );
        await _isar.songs.put(newSong);
      }
    });
  }

  Future<void> _addOrUpdateSongs(
    List<Map<String, dynamic>> metadataList,
  ) async {
    await _isar.writeTxn(() async {
      for (var metadata in metadataList) {
        String? thumbnailPath = await _saveThumbnail(metadata);

        Song? existingSong = await _isar.songs
            .filter()
            .filePathEqualTo(metadata['filePath'])
            .findFirst();

        if (existingSong != null) {
          if (existingSong.lastModified != metadata['lastModified']) {
            existingSong
              ..title = _ensureString(metadata['title']) ?? existingSong.title
              ..artist =
                  _ensureString(metadata['artist']) ?? existingSong.artist
              ..album = _ensureString(metadata['album']) ?? existingSong.album
              ..genre = _ensureString(metadata['genre']) ?? existingSong.genre
              ..lastModified = metadata['lastModified']
              ..thumbnailPath = thumbnailPath ?? existingSong.thumbnailPath;
            await _isar.songs.put(existingSong);
          }
        } else {
          Song newSong = Song(
            title: _ensureString(metadata['title']) ?? 'Unknown Title',
            artist: _ensureString(metadata['artist']) ?? 'Unknown Artist',
            album: _ensureString(metadata['album']) ?? 'Unknown Album',
            genre: _ensureString(metadata['genre']) ?? 'Unknown Genre',
            filePath: metadata['filePath'],
            lastModified: metadata['lastModified'],
            thumbnailPath: thumbnailPath,
          );
          await _isar.songs.put(newSong);
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

  Future<void> cleanupNonExistentEntries() async {
    await _isar.writeTxn(() async {
      final allSongs = await _isar.songs.where().findAll();
      for (final song in allSongs) {
        if (!File(song.filePath).existsSync()) {
          await _isar.songs.delete(song.id);
        }
      }
    });
  }

  Future<String?> _saveThumbnail(Map<String, dynamic> metadata) async {
    Uint8List? imageData;
    if (metadata['cover'] is Uint8List) {
      imageData = metadata['cover'];
    } else if (metadata['picture'] is Map<String, dynamic>) {
      imageData = metadata['picture']['data'];
    }

    if (imageData != null) {
      final hash = sha256.convert(imageData).toString();
      final thumbnailPath = path.join(_thumbnailDirectory.path, '$hash.jpg');
      final thumbnailFile = File(thumbnailPath);
      if (!await thumbnailFile.exists()) {
        await thumbnailFile.writeAsBytes(imageData);
      }
      return thumbnailPath;
    }

    return null;
  }

  Future<int> songsCount() async {
    return _isar.songs.count();
  }

  Future<List<Song>> getSongs(int limit, int offset) {
    final query = _isar.songs.where();
    return query.offset(offset).limit(limit).findAll();
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
    await _isar.close();
    if (!_indexingProgressController.isClosed) {
      await _indexingProgressController.close();
    }
    if (!_indexingErrorsController.isClosed) {
      await _indexingErrorsController.close();
    }
  }
}

@Riverpod(keepAlive: true)
MediaQuery mediaQuery(MediaQueryRef ref) {
  final mq = MediaQuery();
  ref.onDispose(() => mq.dispose());
  return mq;
}

@riverpod
FutureOr<int> songsCount(SongsCountRef ref) {
  return ref.watch(mediaQueryProvider).songsCount();
}

@riverpod
class SongsQuery extends _$SongsQuery {
  @override
  FutureOr<List<Song>> build(int limit, int offset) {
    return ref.watch(mediaQueryProvider).getSongs(limit, offset);
  }
}

@Riverpod(keepAlive: true)
class MediaQueryController extends _$MediaQueryController {
  @override
  FutureOr<void> build() {
    final mQuery = ref.watch(mediaQueryProvider);
    final filterConfigs = ref.watch(songsFilterConfigsProvider);

    return mQuery.initialize(filterConfigs.filterPaths);
  }
}

@riverpod
Stream<int> indexingProgress(IndexingProgressRef ref) {
  return ref.watch(mediaQueryProvider).indexingProgress;
}

class MediaQueryView extends ConsumerWidget {
  const MediaQueryView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQueryControllerAsyncValue =
        ref.watch(mediaQueryControllerProvider);

    return mediaQueryControllerAsyncValue.when(
      data: (data) {
        return const MediaQueryListView();
      },
      error: (error, stackTrace) {
        return AsyncErrorView(error: error, stackTrace: stackTrace);
      },
      loading: () => const MediaQueryViewLoading(),
    );
  }
}

class MediaQueryListView extends ConsumerWidget {
  const MediaQueryListView({super.key});

  static const pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsCountAsyncValue = ref.watch(songsCountProvider);

    return songsCountAsyncValue.when(
      data: (itemCount) {
        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            final page = index ~/ pageSize;
            final offset = page * pageSize;
            final indexInPage = index % pageSize;
            final songsQueryAsyncValue =
                ref.watch(songsQueryProvider(pageSize, offset));
            return songsQueryAsyncValue.when(
              data: (data) {
                final song = data.elementAt(indexInPage);
                return ListTile(
                  leading: Text(song.id.toString()),
                  title: Text(song.title),
                  subtitle: Text(
                      'index: $index, page: $page, indexInPage: $indexInPage, ${offset}'),
                );
              },
              error: (error, stackTrace) {
                return ListTile(
                  leading: const Icon(FluentIcons.warning_24_regular),
                  title: const Text("Error"),
                  subtitle: Text(error.toString()),
                );
              },
              loading: () {
                return const SongListTileLoading();
              },
            );
          },
        );
      },
      error: (error, stackTrace) {
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

class MediaQueryViewLoading extends ConsumerWidget {
  const MediaQueryViewLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexingProgressAsyncValue = ref.watch(indexingProgressProvider);

    return Column(
      children: <Widget>[
        const CircularProgressIndicator(),
        indexingProgressAsyncValue.when(
          data: (data) {
            return Text(data.toString());
          },
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
