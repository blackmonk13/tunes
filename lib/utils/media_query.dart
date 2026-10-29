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
import 'package:tunes/utils/search_text.dart';
import 'package:tunes/providers/providers.dart';
import 'package:watcher/watcher.dart';

part 'media_query.g.dart';

@collection
class Song {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;

  @Index()
  final artist = IsarLink<Artist>();

  @Index()
  final album = IsarLink<Album>();

  @Index()
  final genre = IsarLink<Genre>();

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

  /// Folded "title artist album genre" text that song search matches against.
  String searchKey = '';

  /// Folded lyrics, empty when the file has none.
  String lyricsKey = '';

  /// The [searchIndexVersion] this song was indexed with.
  int searchVersion = 0;

  /// The user's own labels on this song.
  @Backlink(to: 'songs')
  final labels = IsarLinks<Label>();

  Song({
    required this.title,
    required this.filePath,
    required this.lastModified,
    required this.duration,
    required this.size,
    this.thumbnailPath,
    this.thumbnailMiniPath,
  });
}

/// A user-defined tag that can be attached to any number of songs.
@collection
class Label {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false, type: IndexType.value)
  late String name;

  final songs = IsarLinks<Song>();
}

@collection
class Playlist {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false, type: IndexType.value)
  late String name;

  final songs = IsarLinks<Song>();
}

@collection
class Artist {
  Id id = Isar.autoIncrement;

  @Index(
    // unique: true,
    caseSensitive: false,
    type: IndexType.value,
  )
  late String name;

  String? description;
  String? artworkPath;

  final songs = IsarLinks<Song>();
  final albums = IsarLinks<Album>();
}

@collection
class Album {
  Id id = Isar.autoIncrement;

  @Index(
    // unique: true,
    caseSensitive: false,
    type: IndexType.value,
  )
  late String title;

  final artist = IsarLink<Artist>();
  String? description;
  String? artworkPath;
  int? releaseYear;

  final songs = IsarLinks<Song>();
}

@collection
class Genre {
  Id id = Isar.autoIncrement;

  @Index(
    // unique: true,
    caseSensitive: false,
    type: IndexType.value,
  )
  late String name;

  String? description;

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
  none,
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
          for (var element in songs)
            element.filePath: element.searchVersion < searchIndexVersion
                ? -1 // forces a re-read so the search text gets filled in
                : element.lastModified
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
    if (value is List) return value.join(', ');
    return value.toString();
  }

  static void _applySearchIndex(
    Song song,
    Metadata metadata,
    String artistName,
    String albumTitle,
    String genreName,
  ) {
    song
      ..searchKey = foldForSearch(
        '${song.title} $artistName $albumTitle $genreName',
      )
      ..lyricsKey = foldForSearch(_lyricsOf(metadata) ?? '')
      ..searchVersion = searchIndexVersion;
  }

  /// MP4 files store lyrics under `lyrics`, ID3 files under
  /// `unsynchronizedLyrics` (a map with the text under `text`).
  static String? _lyricsOf(Metadata metadata) {
    final plain = _ensureString(metadata.get('lyrics'));
    if (plain != null && plain.isNotEmpty) return plain;

    final unsynchronized = metadata.get('unsynchronizedLyrics');
    if (unsynchronized is Map) return _ensureString(unsynchronized['text']);
    if (unsynchronized is List) {
      return unsynchronized
          .map((entry) => entry is Map ? entry['text'] : entry)
          .whereType<String>()
          .join('\n');
    }
    return null;
  }

  Future<void> _addOrUpdateSong(Metadata metadata) async {
    await _isar.writeTxn(() async {
      final thumbnailPaths = await _saveThumbnail(metadata);

      final artistName =
          _ensureString(metadata.get('artist')) ?? 'Unknown Artist';
      final albumTitle =
          _ensureString(metadata.get('album')) ?? 'Unknown Album';
      final genreName = _ensureString(metadata.get('genre')) ?? 'Unknown Genre';

      final artist = await _getOrCreateArtist(artistName);
      final album = await _getOrCreateAlbum(albumTitle, artist);
      final genre = await _getOrCreateGenre(genreName);

      Song song = await _isar.songs
              .filter()
              .filePathEqualTo(metadata.get('filePath'))
              .findFirst() ??
          Song(
            title: _ensureString(metadata.get('title')) ?? 'Unknown Title',
            filePath: metadata.get('filePath'),
            lastModified: metadata.get('lastModified'),
            duration: metadata.get('duration') ?? 0,
            size: metadata.get('size') ?? 0,
            thumbnailPath: thumbnailPaths.original,
            thumbnailMiniPath: thumbnailPaths.mini,
          );

      song
        ..title = _ensureString(metadata.get('title')) ?? song.title
        ..lastModified = metadata.get('lastModified')
        ..duration = metadata.get('duration') ?? song.duration
        ..size = metadata.get('size') ?? song.size
        ..thumbnailPath = thumbnailPaths.original ?? song.thumbnailPath
        ..thumbnailMiniPath = thumbnailPaths.mini ?? song.thumbnailMiniPath;
      _applySearchIndex(song, metadata, artistName, albumTitle, genreName);

      song.artist.value = artist;
      song.album.value = album;
      song.genre.value = genre;

      await _isar.songs.put(song);
      await song.artist.save();
      await song.album.save();
      await song.genre.save();

      artist.songs.add(song);
      artist.albums.add(album);
      album.songs.add(song);
      genre.songs.add(song);

      await artist.songs.save();
      await artist.albums.save();
      await album.songs.save();
      await genre.songs.save();
    });
  }

  Future<void> _addOrUpdateSongs(List<Metadata> metadataList) async {
    await _isar.writeTxn(() async {
      for (var metadata in metadataList) {
        if (metadata.get('deleted') == true) {
          await _removeSong(metadata.get('filePath'));
        } else {
          final thumbnailPaths = await _saveThumbnail(metadata);

          final artistName =
              _ensureString(metadata.get('artist')) ?? 'Unknown Artist';
          final albumTitle =
              _ensureString(metadata.get('album')) ?? 'Unknown Album';
          final genreName =
              _ensureString(metadata.get('genre')) ?? 'Unknown Genre';

          final artist = await _getOrCreateArtist(artistName);
          final album = await _getOrCreateAlbum(albumTitle, artist);
          final genre = await _getOrCreateGenre(genreName);

          Song song = await _isar.songs
                  .filter()
                  .filePathEqualTo(metadata.get('filePath'))
                  .findFirst() ??
              Song(
                title: _ensureString(metadata.get('title')) ?? 'Unknown Title',
                filePath: metadata.get('filePath'),
                lastModified: metadata.get('lastModified'),
                duration: metadata.get('duration') ?? 0,
                size: metadata.get('size') ?? 0,
                thumbnailPath: thumbnailPaths.original,
                thumbnailMiniPath: thumbnailPaths.mini,
              );

          song
            ..title = _ensureString(metadata.get('title')) ?? song.title
            ..lastModified = metadata.get('lastModified')
            ..duration = metadata.get('duration') ?? song.duration
            ..size = metadata.get('size') ?? song.size
            ..thumbnailPath = thumbnailPaths.original ?? song.thumbnailPath
            ..thumbnailMiniPath = thumbnailPaths.mini ?? song.thumbnailMiniPath;
          _applySearchIndex(song, metadata, artistName, albumTitle, genreName);

          song.artist.value = artist;
          song.album.value = album;
          song.genre.value = genre;

          await _isar.songs.put(song);
          await song.artist.save();
          await song.album.save();
          await song.genre.save();

          artist.songs.add(song);
          artist.albums.add(album);
          album.songs.add(song);
          genre.songs.add(song);

          await artist.songs.save();
          await artist.albums.save();
          await album.songs.save();
          await genre.songs.save();
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
            _removeSongTxn(event.path);
          }
        });
        _watchers.add(subscription);
      }
    }
  }

  Future<Artist> _getOrCreateArtist(String name) async {
    var artist = await _isar.artists.filter().nameEqualTo(name).findFirst();
    if (artist == null) {
      artist = Artist()..name = name;
      await _isar.artists.put(artist);
    }
    return artist;
  }

  Future<Album> _getOrCreateAlbum(String title, Artist artist) async {
    var album = await _isar.albums.filter().titleEqualTo(title).findFirst();
    if (album == null) {
      album = Album()
        ..title = title
        ..artist.value = artist;
      await _isar.albums.put(album);
      await album.artist.save();
    }
    return album;
  }

  Future<Genre> _getOrCreateGenre(String name) async {
    var genre = await _isar.genres.filter().nameEqualTo(name).findFirst();
    if (genre == null) {
      genre = Genre()..name = name;
      await _isar.genres.put(genre);
    }
    return genre;
  }

  Future<void> _removeSong(String filePath) async {
    final song =
        await _isar.songs.filter().filePathEqualTo(filePath).findFirst();
    if (song != null) {
      await song.artist.load();
      await song.album.load();
      await song.genre.load();

      if (song.artist.value != null) {
        song.artist.value!.songs.remove(song);
        await song.artist.value!.songs.save();
      }
      if (song.album.value != null) {
        song.album.value!.songs.remove(song);
        await song.album.value!.songs.save();
      }
      if (song.genre.value != null) {
        song.genre.value!.songs.remove(song);
        await song.genre.value!.songs.save();
      }

      await _isar.songs.delete(song.id);
    }
  }

  Future<void> _removeSongTxn(String filePath) async {
    final song =
        await _isar.songs.filter().filePathEqualTo(filePath).findFirst();
    if (song != null) {
      await _isar.writeTxn(() async {
        await song.artist.load();
        await song.album.load();
        await song.genre.load();

        if (song.artist.value != null) {
          song.artist.value!.songs.remove(song);
          await song.artist.value!.songs.save();
        }
        if (song.album.value != null) {
          song.album.value!.songs.remove(song);
          await song.album.value!.songs.save();
        }
        if (song.genre.value != null) {
          song.genre.value!.songs.remove(song);
          await song.genre.value!.songs.save();
        }

        await _isar.songs.delete(song.id);
      });
    }
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
    List<int> indices = const [],
  }) {
    final tokens = searchQuery == null ? <String>[] : searchTokens(searchQuery);
    final withSearchQuery = tokens.isNotEmpty;
    final withQueryType = ![
          SongQueryType.all,
          SongQueryType.playlist,
        ].contains(queryType) &&
        query != null;
    _logger.w(indices);
    return _isar.songs
        .where()
        .optional(
          withQueryType || withSearchQuery || indices.isNotEmpty,
          (q) {
            return q
                .filter()
                .optional(indices.isNotEmpty, (qi) {
                  return qi.anyOf(indices, (qa, id) {
                    return qa.idEqualTo(id);
                  });
                })
                .and()
                .optional(withQueryType, (qt) {
                  switch (queryType) {
                    case SongQueryType.album:
                      return qt.album((qal) => qal.titleEqualTo(query!));
                    case SongQueryType.artist:
                      return qt.artist((qar) => qar.nameEqualTo(query!));
                    case SongQueryType.genre:
                      return qt.genre((qg) => qg.nameEqualTo(query!));
                    default:
                      return qt.filePathIsNotEmpty();
                  }
                })
                .and()
                .optional(
                  withSearchQuery,
                  (sq) {
                    // Every word must appear somewhere in the metadata, the
                    // lyrics or a label, in any order.
                    return sq.allOf(tokens, (qt, token) {
                      return qt.group(
                        (g) => g
                            .searchKeyContains(token)
                            .or()
                            .lyricsKeyContains(token)
                            .or()
                            .labels(
                              (l) => l.nameContains(
                                token,
                                caseSensitive: false,
                              ),
                            ),
                      );
                    });
                  },
                );
          },
        )
        .optional(sortType != SongsSortType.none, (qs) {
          switch (sort) {
            case Sort.asc:
              switch (sortType) {
                case SongsSortType.title:
                  return qs.sortByTitle();
                case SongsSortType.duration:
                  return qs.sortByDuration();
                case SongsSortType.size:
                  return qs.sortBySize();
                case SongsSortType.modified:
                default:
                  return qs.sortByLastModified();
              }
            case Sort.desc:
              switch (sortType) {
                case SongsSortType.title:
                  return qs.sortByTitleDesc();
                case SongsSortType.duration:
                  return qs.sortByDurationDesc();
                case SongsSortType.size:
                  return qs.sortBySizeDesc();
                case SongsSortType.modified:
                default:
                  return qs.sortByLastModifiedDesc();
              }
          }
        })
        .optional(offset != null, (q) => q.offset(offset!))
        .optional(limit != null, (q) => q.limit(limit!))
        .build();
  }

  Query<Album> queryAlbums({
    int? limit,
    int? offset,
    Sort sort = Sort.desc,
    String? artist,
    String? searchQuery,
  }) {
    final withSearchQuery = searchQuery != null;
    return _isar.albums
        .where()
        .optional(
          withSearchQuery,
          (q) {
            return q.filter().optional(
              withSearchQuery,
              (sq) {
                return sq
                    .titleContains(
                      searchQuery!,
                      caseSensitive: false,
                    )
                    .or()
                    .artist(
                  (qar) {
                    return qar
                        .nameContains(searchQuery)
                        .or()
                        .descriptionContains(searchQuery);
                  },
                );
              },
            );
          },
        )
        .optional(offset != null, (q) => q.offset(offset!))
        .optional(limit != null, (q) => q.limit(limit!))
        .build();
  }

  Query<Artist> queryArtists({
    int? limit,
    int? offset,
    Sort sort = Sort.desc,
    String? searchQuery,
  }) {
    final withSearchQuery = searchQuery != null;
    return _isar.artists
        .where()
        .optional(
          withSearchQuery,
          (q) {
            return q.filter().optional(
              withSearchQuery,
              (sq) {
                return sq.nameContains(
                  searchQuery!,
                  caseSensitive: false,
                );
              },
            );
          },
        )
        .optional(offset != null, (q) => q.offset(offset!))
        .optional(limit != null, (q) => q.limit(limit!))
        .build();
  }

  Query<Genre> queryGenres({
    int? limit,
    int? offset,
    Sort sort = Sort.desc,
    String? artist,
    String? searchQuery,
  }) {
    final withSearchQuery = searchQuery != null;
    return _isar.genres
        .where()
        .optional(
          withSearchQuery,
          (q) {
            return q.filter().optional(
              withSearchQuery,
              (sq) {
                return sq.nameContains(
                  searchQuery!,
                  caseSensitive: false,
                );
              },
            );
          },
        )
        .optional(offset != null, (q) => q.offset(offset!))
        .optional(limit != null, (q) => q.limit(limit!))
        .build();
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
    [
      SongSchema,
      ArtistSchema,
      AlbumSchema,
      GenreSchema,
      PlaylistSchema,
      LabelSchema,
    ],
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
  List<int> indices = const [],
}) {
  return ref
      .watch(mediaQueryProvider)
      .querySongs(
        queryType: queryType,
        query: query,
        searchQuery: searchQuery,
        indices: indices,
      )
      .watchLazy();
}

@riverpod
FutureOr<int> songsCount(
  SongsCountRef ref, {
  SongQueryType queryType = SongQueryType.all,
  String? query,
  String? searchQuery,
  List<int> indices = const [],
}) {
  ref.watch(songsWatcherProvider(
    queryType: queryType,
    query: query,
    searchQuery: searchQuery,
    indices: indices,
  ));
  return ref
      .watch(mediaQueryProvider)
      .querySongs(
        queryType: queryType,
        query: query,
        searchQuery: searchQuery,
        indices: indices,
      )
      .count();
}

@riverpod
class SongsQuery extends _$SongsQuery {
  @override
  FutureOr<List<Song>> build({
    int? limit,
    int? offset,
    SongQueryType queryType = SongQueryType.all,
    String? query,
    String? searchQuery,
    List<int> indices = const [],
  }) {
    final songsSortOrder = ref.watch(
      songsSortOrderProvider(
        SongQueryType.all,
      ),
    );
    return ref
        .watch(mediaQueryProvider)
        .querySongs(
          limit: limit,
          offset: offset,
          sort: songsSortOrder.orderType,
          sortType: songsSortOrder.sortType,
          queryType: queryType,
          query: query,
          searchQuery: searchQuery,
          indices: indices,
        )
        .findAll();
  }
}

@riverpod
Stream<void> albumsWatcher(
  AlbumsWatcherRef ref, {
  String? searchQuery,
}) {
  return ref
      .watch(mediaQueryProvider)
      .queryAlbums(
        searchQuery: searchQuery,
      )
      .watchLazy();
}

@riverpod
FutureOr<int> albumsCount(
  AlbumsCountRef ref, {
  String? searchQuery,
}) {
  ref.watch(albumsWatcherProvider(
    searchQuery: searchQuery,
  ));
  return ref
      .watch(mediaQueryProvider)
      .queryAlbums(
        searchQuery: searchQuery,
      )
      .count();
}

@riverpod
class AlbumsQuery extends _$AlbumsQuery {
  @override
  FutureOr<List<Album>> build(
    int limit,
    int offset, {
    SongQueryType queryType = SongQueryType.all,
    String? query,
    String? searchQuery,
  }) {
    // final songsSortOrder = ref.watch(
    //   songsSortOrderProvider(
    //     SongQueryType.all,
    //   ),
    // );
    return ref
        .watch(mediaQueryProvider)
        .queryAlbums(
          limit: limit,
          offset: offset,
          // sort: songsSortOrder.orderType,
          searchQuery: searchQuery,
        )
        .findAll();
  }
}

@riverpod
Stream<void> artistsWatcher(
  ArtistsWatcherRef ref, {
  String? searchQuery,
}) {
  return ref
      .watch(mediaQueryProvider)
      .queryArtists(
        searchQuery: searchQuery,
      )
      .watchLazy();
}

@riverpod
FutureOr<int> artistsCount(
  ArtistsCountRef ref, {
  String? searchQuery,
}) {
  ref.watch(artistsWatcherProvider(
    searchQuery: searchQuery,
  ));
  return ref
      .watch(mediaQueryProvider)
      .queryArtists(
        searchQuery: searchQuery,
      )
      .count();
}

@riverpod
class ArtistsQuery extends _$ArtistsQuery {
  @override
  FutureOr<List<Artist>> build(
    int limit,
    int offset, {
    String? searchQuery,
  }) {
    return ref
        .watch(mediaQueryProvider)
        .queryArtists(
          limit: limit,
          offset: offset,
          searchQuery: searchQuery,
        )
        .findAll();
  }
}

@riverpod
Stream<void> genresWatcher(
  GenresWatcherRef ref, {
  String? searchQuery,
}) {
  return ref
      .watch(mediaQueryProvider)
      .queryGenres(
        searchQuery: searchQuery,
      )
      .watchLazy();
}

@riverpod
FutureOr<int> genresCount(
  GenresCountRef ref, {
  String? searchQuery,
}) {
  ref.watch(genresWatcherProvider(
    searchQuery: searchQuery,
  ));
  return ref
      .watch(mediaQueryProvider)
      .queryGenres(
        searchQuery: searchQuery,
      )
      .count();
}

@riverpod
class GenresQuery extends _$GenresQuery {
  @override
  FutureOr<List<Genre>> build(
    int limit,
    int offset, {
    String? searchQuery,
  }) {
    return ref
        .watch(mediaQueryProvider)
        .queryGenres(
          limit: limit,
          offset: offset,
          searchQuery: searchQuery,
        )
        .findAll();
  }
}
