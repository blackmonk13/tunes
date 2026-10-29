part of 'providers.dart';

/// Every cover embedded in the audio file at [filePath].
///
/// The file is read in another isolate, so large tags do not block the UI.
@riverpod
Future<List<SongCover>> songCovers(SongCoversRef ref, String filePath) {
  return Isolate.run(() {
    final handler = AudioQuery.createCodecHandler(filePath);
    if (handler == null) return <SongCover>[];

    return coversFromMetadata(handler.metadata);
  });
}

/// Writes [covers] into the file, replacing the covers that are there. An empty
/// list removes them all.
///
/// A top-level function, so the isolate does not capture a provider.
Future<void> _writeCovers(String filePath, List<SongCover> covers) {
  return Isolate.run(() async {
    final handler = AudioQuery.createCodecHandler(filePath);
    if (handler == null) {
      throw Exception('Cannot edit the covers of $filePath');
    }

    final key = coverKeyFor(handler);
    if (covers.isEmpty) {
      handler.removeMetadata([key]);
    } else {
      handler.updateMetadata({
        key: [for (final cover in covers) coverWriteValue(handler, cover)],
      });
    }
    await handler.applyMetadataChanges();
  });
}

@riverpod
class CoversController extends _$CoversController {
  @override
  void build() {}

  /// Adds [bytes] after the covers the file already has.
  Future<void> add(String filePath, Uint8List bytes) async {
    final covers = await ref.read(songCoversProvider(filePath).future);

    await _writeCovers(filePath, [
      ...covers,
      // The first cover is the front cover; later ones are just "other".
      SongCover(bytes: bytes, pictureType: covers.isEmpty ? 3 : 0),
    ]);
    ref.invalidate(songCoversProvider(filePath));
  }

  /// Removes the cover at [index].
  Future<void> remove(String filePath, int index) async {
    final covers = await ref.read(songCoversProvider(filePath).future);
    if (index < 0 || index >= covers.length) return;

    await _writeCovers(filePath, [...covers]..removeAt(index));
    ref.invalidate(songCoversProvider(filePath));
  }
}
