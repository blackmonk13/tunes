import 'dart:typed_data';

import 'package:mpeg_codec/mpeg_codec.dart'
    show CodecHandler, Metadata, MP4Handler;

/// One piece of cover art embedded in an audio file.
class SongCover {
  const SongCover({
    required this.bytes,
    this.mimeType,
    this.pictureType,
    this.description,
  });

  final Uint8List bytes;
  final String? mimeType;

  /// The ID3 picture type (3 is the front cover). MP4 files have no types.
  final int? pictureType;
  final String? description;

  /// A short name for the kind of picture, such as "Front cover".
  String get label => _pictureTypeNames[pictureType] ?? 'Cover';
}

const _pictureTypeNames = {
  0: 'Other',
  1: 'File icon',
  2: 'Other icon',
  3: 'Front cover',
  4: 'Back cover',
  5: 'Leaflet',
  6: 'Media',
  7: 'Lead artist',
  8: 'Artist',
  9: 'Conductor',
  10: 'Band',
  11: 'Composer',
  12: 'Lyricist',
  13: 'Recording location',
  14: 'During recording',
  15: 'During performance',
  16: 'Screen capture',
  18: 'Illustration',
  19: 'Band logo',
  20: 'Publisher logo',
};

/// Reads every cover from [metadata]: `pictures` (a list of maps) for ID3
/// files and `covers` (a list of image bytes) for MP4 files, falling back to
/// the single `picture` or `cover` value.
List<SongCover> coversFromMetadata(Metadata metadata) {
  final pictures = metadata.get('pictures');
  if (pictures is List && pictures.isNotEmpty) {
    return [
      for (final picture in pictures)
        if (picture is Map && picture['data'] is Uint8List)
          SongCover(
            bytes: picture['data'] as Uint8List,
            mimeType: picture['mimeType'] as String?,
            pictureType: picture['pictureType'] as int?,
            description: picture['description'] as String?,
          ),
    ];
  }

  final covers = metadata.get('covers');
  if (covers is List && covers.isNotEmpty) {
    return [
      for (final cover in covers)
        if (cover is Uint8List) SongCover(bytes: cover),
    ];
  }

  final picture = metadata.get('picture');
  if (picture is Map && picture['data'] is Uint8List) {
    return [
      SongCover(
        bytes: picture['data'] as Uint8List,
        mimeType: picture['mimeType'] as String?,
        pictureType: picture['pictureType'] as int?,
        description: picture['description'] as String?,
      ),
    ];
  }

  final cover = metadata.get('cover');
  if (cover is Uint8List) return [SongCover(bytes: cover)];

  return [];
}

/// The metadata key cover art is written under: `cover` for MP4 files and
/// `picture` for ID3 files.
String coverKeyFor(CodecHandler handler) {
  return handler is MP4Handler ? 'cover' : 'picture';
}

/// The value to write for [cover]: image bytes for MP4 files, and a map that
/// keeps the picture type and description for ID3 files.
Object coverWriteValue(CodecHandler handler, SongCover cover) {
  if (handler is MP4Handler) return cover.bytes;

  return {
    'data': cover.bytes,
    if (cover.mimeType != null) 'mimeType': cover.mimeType,
    'pictureType': cover.pictureType ?? 3,
    'description': cover.description ?? 'Cover',
  };
}

/// Whether [value] is, or holds, raw bytes that are not worth showing as text.
bool isBinaryMetadata(Object? value) {
  if (value is Uint8List) return true;
  if (value is List) return value.any(isBinaryMetadata);
  if (value is Map) return value.values.any(isBinaryMetadata);
  return false;
}
