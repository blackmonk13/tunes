import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:mpeg_codec/mpeg_codec.dart';
import 'package:path/path.dart' as path;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  late String filePath;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.filePath,
  });
}

class IndexingProgress {
  final int totalFiles;
  final int processedFiles;

  IndexingProgress(this.totalFiles, this.processedFiles);
}

class MediaQuery {
  late Isar _isar;
  List<StreamSubscription<FileSystemEvent>> _watchers = [];
  final _indexingProgressController =
      StreamController<IndexingProgress>.broadcast();

  Stream<IndexingProgress> get indexingProgress =>
      _indexingProgressController.stream;

  Future<void> initialize(List<String> paths) async {
    final dir = await getApplicationSupportDirectory();
    // Initialize Isar
    _isar = await Isar.open(
      [SongSchema],
      directory: dir.path,
    );

    // Index media files
    await _indexMedia(paths);

    // Set up directory watchers
    _setupWatchers(paths);
  }

  Future<void> _indexMedia(List<String> paths) async {
    final totalFiles = await _countMp3Files(paths);
    int processedFiles = 0;

    final receivePort = ReceivePort();
    await Isolate.spawn(_indexMediaIsolate, [paths, receivePort.sendPort]);

    await for (var message in receivePort) {
      if (message is Map<String, String>) {
        await _addOrUpdateSong(message, message['filePath']!);
        processedFiles++;
        _indexingProgressController
            .add(IndexingProgress(totalFiles, processedFiles));
      } else if (message == 'DONE') {
        break;
      }
    }

    _indexingProgressController.close();
  }

  static void _indexMediaIsolate(List<dynamic> args) async {
    List<String> paths = args[0];
    SendPort sendPort = args[1];

    for (var dirPath in paths) {
      var dir = Directory(dirPath);
      await for (var entity in dir.list(recursive: true)) {
        if (entity is File &&
            path.extension(entity.path).toLowerCase() == '.mp3') {
          var metadata = await _extractMetadata(entity.path);
          metadata['filePath'] = entity.path;
          sendPort.send(metadata);
        }
      }
    }

    sendPort.send('DONE');
  }

  Future<void> _processFile(String filePath) async {
    var metadata = await _extractMetadata(filePath);
    await _addOrUpdateSong(metadata, filePath);
  }

  static Future<Map<String, String>> _extractMetadata(String filePath) async {
    final handler = ID3Handler(filePath);
    final metadata = handler.metadata;

    return {
      'title': metadata.get('title') ?? path.basenameWithoutExtension(filePath),
      'artist': metadata.get('artist') ?? 'Unknown Artist',
      'album': metadata.get('album') ?? 'Unknown Album',
      'genre': metadata.get('genre') ?? 'Unknown Genre',
    };
  }

  Future<void> _addOrUpdateSong(Map<String, String> metadata, String filePath) async {
    await _isar.writeTxn(() async {
      var existingSong = await _isar.songs
          .filter()
          .filePathEqualTo(filePath)
          .findFirst();

      if (existingSong != null) {
        existingSong
          ..title = metadata['title']!
          ..artist = metadata['artist']!
          ..album = metadata['album']!
          ..genre = metadata['genre']!;
        await _isar.songs.put(existingSong);
      } else {
        var newSong = Song(
          title: metadata['title']!,
          artist: metadata['artist']!,
          album: metadata['album']!,
          genre: metadata['genre']!,
          filePath: filePath,
        );
        await _isar.songs.put(newSong);
      }
    });
  }

  Future<int> _countMp3Files(List<String> paths) async {
    int count = 0;
    for (var dirPath in paths) {
      var dir = Directory(dirPath);
      await for (var entity in dir.list(recursive: true)) {
        if (entity is File &&
            path.extension(entity.path).toLowerCase() == '.mp3') {
          count++;
        }
      }
    }
    return count;
  }

  void _setupWatchers(List<String> paths) {
    for (var dirPath in paths) {
      var watcher = Directory(dirPath).watch(recursive: true).listen((event) {
        if (event.type == FileSystemEvent.create ||
            event.type == FileSystemEvent.modify) {
          if (path.extension(event.path).toLowerCase() == '.mp3') {
            _processFile(event.path);
          }
        } else if (event.type == FileSystemEvent.delete) {
          _removeSong(event.path);
        }
      });
      _watchers.add(watcher);
    }
  }

  Future<void> _removeSong(String filePath) async {
    await _isar.writeTxn(() async {
      await _isar.songs.filter().filePathEqualTo(filePath).deleteAll();
    });
  }

  Future<List<Song>> getSongs({
    String? artistFilter,
    String? albumFilter,
    String? genreFilter,
  }) {
    var query = _isar.songs.where();
    // if (artistFilter != null) {
    //   query = query.artistContains(artistFilter, caseSensitive: false);
    // }
    // if (albumFilter != null) {
    //   query = query.albumContains(albumFilter, caseSensitive: false);
    // }
    // if (genreFilter != null) {
    //   query = query.genreContains(genreFilter, caseSensitive: false);
    // }
    return query.findAll();
  }

  // Implement other query methods (getAlbums, getArtists, getGenres, getPlaylists)

  Future<void> dispose() async {
    for (var watcher in _watchers) {
      await watcher.cancel();
    }
    await _isar.close();
  }
}

@riverpod
MediaQuery mediaQuery(MediaQueryRef ref) {
  return MediaQuery();
}