// Obtain shared preferences.
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunes/models/tune.dart';

final player = AudioPlayer();
final tagger = Audiotagger();

Future<String?> pickMediaPath() async {
  final hasPerm = await Permission.manageExternalStorage.request().isGranted;
  final hasStorePerm = await Permission.storage.request().isGranted;
  if (!hasPerm && !hasStorePerm) {
    // Either the permission was already granted before or the user just granted it.
    return null;
  }
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory == null) {
    // User canceled the picker
    return null;
  }
  return selectedDirectory;
}

Future<List<String>> getMediaPaths() async {
  final prefs = await SharedPreferences.getInstance();
  final mediaPaths = prefs.getStringList("mediapaths");
  return mediaPaths ?? [];
}

Future<bool> setMediaPaths(String? newPath) async {
  if (newPath == null) {
    return false;
  }

  if (newPath.isEmpty) {
    return false;
  }

  final existingPaths = await getMediaPaths();
  final prefs = await SharedPreferences.getInstance();
  final isSaved = await prefs.setStringList(
    "mediapaths",
    [...existingPaths, newPath],
  );
  return isSaved;
}

Stream<FileSystemEntity> getMusic(List<String> directories) async* {
  final songs = MergeStream(
    directories.map(
      (folder) {
        final fdir = Directory(folder);
        return fdir.list(recursive: true);
      },
    ),
  );

  await for (final entity in songs) {
    
    if (entity is File && isMusicFile(entity) && entity.statSync().size > 100) {
      yield entity;
    }
  }
}

bool isMusicFile(FileSystemEntity file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType?.startsWith('audio/') == true;
}

String? getTitle(Tune? tune) {
  if (tune == null) {
    return null;
  }

  final title = tune.tag?.title;
  if (title == null || title.isEmpty) {
    return basenameWithoutExtension(tune.filePath);
  }
  return title;
}

String? getArtist(Tune? tune) {
  if (tune == null) {
    return null;
  }

  final albumArtist = tune.tag?.albumArtist;
  final artist = tune.tag?.artist;

  if (albumArtist == null || albumArtist.isEmpty) {
    if (artist == null || artist.isEmpty) {
      return null;
    }
    return artist;
  }

  return albumArtist;
}

String? getAlbum(Tune? tune) {
  if (tune == null) {
    return null;
  }

  final album = tune.tag?.album;
  if (album == null) {
    return null;
  }
  if (album.isEmpty) {
    return null;
  }
  return album;
}
