// Obtain shared preferences.
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final player = AssetsAudioPlayer();
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

String getTitle({required String filePath, Tag? tag}) {
  final pathAsTitle = basenameWithoutExtension(filePath);
  if (tag == null) {
    return pathAsTitle;
  }

  final title = tag.title;
  if (title == null || title.isEmpty) {
    return pathAsTitle;
  }
  return title;
}

String getArtist(Tag? tag) {
  const unknown = "Unknown";
  if (tag == null) {
    return unknown;
  }

  final albumArtist = tag.albumArtist;
  final artist = tag.artist;

  if (albumArtist == null || albumArtist.isEmpty) {
    if (artist == null || artist.isEmpty) {
      return unknown;
    }
    return artist;
  }

  return albumArtist;
}

String getAlbum(Tag? tag) {
  const unknown = "Unknown";
  if (tag == null) {
    return unknown;
  }

  final album = tag.album;
  if (album == null) {
    return unknown;
  }
  if (album.isEmpty) {
    return unknown;
  }
  return album;
}
