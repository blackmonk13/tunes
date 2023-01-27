import 'package:audiotagger/models/tag.dart';
import 'package:flutter/services.dart';
import 'package:tunes/utils/constants.dart';

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
