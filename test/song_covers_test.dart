import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mpeg_codec/mpeg_codec.dart' show Metadata;
import 'package:tunes/utils/song_covers.dart';

Uint8List _bytes(int fill) => Uint8List.fromList([fill, fill, fill]);

void main() {
  group('coversFromMetadata', () {
    test('reads every ID3 picture with its type and description', () {
      final metadata = Metadata()
        ..set('pictures', [
          {
            'mimeType': 'image/jpeg',
            'pictureType': 3,
            'description': 'Front',
            'data': _bytes(1),
          },
          {
            'mimeType': 'image/png',
            'pictureType': 4,
            'description': 'Back',
            'data': _bytes(2),
          },
        ]);

      final covers = coversFromMetadata(metadata);

      expect(covers, hasLength(2));
      expect(covers[0].bytes, _bytes(1));
      expect(covers[0].label, 'Front cover');
      expect(covers[1].label, 'Back cover');
      expect(covers[1].mimeType, 'image/png');
    });

    test('reads every MP4 cover', () {
      final metadata = Metadata()..set('covers', [_bytes(1), _bytes(2)]);

      final covers = coversFromMetadata(metadata);

      expect(covers.map((c) => c.bytes), [_bytes(1), _bytes(2)]);
      expect(covers.first.label, 'Cover');
    });

    test('falls back to a single picture or cover', () {
      expect(
        coversFromMetadata(Metadata()..set('picture', {'data': _bytes(1)})),
        hasLength(1),
      );
      expect(
        coversFromMetadata(Metadata()..set('cover', _bytes(2))),
        hasLength(1),
      );
    });

    test('is empty when there is no cover art', () {
      expect(coversFromMetadata(Metadata()..set('title', 'Song')), isEmpty);
    });

    test('skips entries without image bytes', () {
      final metadata = Metadata()
        ..set('pictures', [
          {'data': 'not bytes'}
        ]);

      expect(coversFromMetadata(metadata), isEmpty);
    });
  });

  group('isBinaryMetadata', () {
    test('is true for bytes and for lists or maps holding bytes', () {
      expect(isBinaryMetadata(_bytes(1)), isTrue);
      expect(isBinaryMetadata([_bytes(1)]), isTrue);
      expect(isBinaryMetadata({'data': _bytes(1), 'type': 3}), isTrue);
    });

    test('is false for text and numbers', () {
      expect(isBinaryMetadata('title'), isFalse);
      expect(isBinaryMetadata(3), isFalse);
      expect(isBinaryMetadata(['a', 'b']), isFalse);
      expect(isBinaryMetadata({'language': 'eng', 'text': 'la la'}), isFalse);
    });
  });
}
