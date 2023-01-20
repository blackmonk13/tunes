import 'dart:io';

import 'package:audiotagger/models/tag.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/utils/constants.dart';

class Tune {
  final String filePath;
  final Uint8List? artWork;
  final Tag? tag;
  Tune({
    required this.filePath,
    this.artWork,
    this.tag,
  });

  File? _file;
  File get file {
    _file ??= File(filePath);
    return _file!;
  }

  UriAudioSource? _audioSource;
  UriAudioSource get audioSource {
    _audioSource ??= AudioSource.file(
      filePath,
      tag: tag,
    );

    return _audioSource!;
  }
}

Future<Uint8List?> getArtwork(String filePath) async {
  final bytes = await tagger.readArtwork(
    path: filePath,
  );
  return bytes;
}

Future<Tag?> getTags(String filePath) async {
  final tagmap = await tagger.readTagsAsMap(path: filePath);
  if (tagmap == null) {
    return null;
  }
  final tag = Tag.fromMap(tagmap);
  return tag;
}
