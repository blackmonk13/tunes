part of 'providers.dart';

@riverpod
class SongsController extends _$SongsController {
  @override
  FutureOr<List<SongModel>> build() {
    return ref.read(onAudioQueryProvider).querySongs(
          sortType: SongSortType.DATE_ADDED,
          orderType: OrderType.DESC_OR_GREATER,
        );
  }
}

@riverpod
FutureOr<List<SongModel>> allSongs(AllSongsRef ref) {
  return ref.read(onAudioQueryProvider).querySongs();
}

@riverpod
FutureOr<SongModel?> songWithId(SongWithIdRef ref, String id) async {
  final intId = int.parse(id);
  final allSongs = await ref.watch(allSongsProvider.future);

  final filteredSongs = allSongs.where((song) {
    return song.id == intId;
  }).toList();

  if (filteredSongs.isNotEmpty) {
    return filteredSongs.first;
  }
  
  return null;
}

@riverpod
FutureOr<SongModel?> currentSongInfo(CurrentSongInfoRef ref) async {
  final currentIndex = await ref.watch(playerCurrentIndexProvider.future);
  final sequence = await ref.watch(playlistSequenceProvider.future);

  if (currentIndex == null || sequence == null) {
    return null;
  }

  if (sequence.isEmpty) {
    return null;
  }

  if (currentIndex >= sequence.length) {
    return null;
  }

  final currentSource = sequence[currentIndex];

  final mediaItem = currentSource.tag as MediaItem?;

  if (mediaItem == null) {
    return null;
  }

  final mediaId = mediaItem.id;

  return ref.watch(songWithIdProvider(mediaId).future);
}

@riverpod
class MetadataController extends _$MetadataController {
  @override
  FutureOr<bool?> build(SongModel song) {
    return null;
  }

  Future<void> encodeSongMetadata(Map<String, dynamic> fields) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // `song.data` should be a path to the file
      final songFile = File(song.data);

      // Check if the file actually exists
      if (!await songFile.exists()) {
        debugPrint("File does not exist");
        throw Exception('File not found');
      }

      // Read the file as bytes
      final bytes = await songFile.readAsBytes();

      // Initialize the encoder with the bytes
      final encoder = ID3Encoder(bytes);

      // Create the metadata body
      final metadata = MetadataV2p4Body(
        title: fields['title'] as String?,
        artist: fields['artist'] as String?,
        album: fields['album'] as String?,
      );

      // Encode the metadata
      final encodedBytes = await encoder.encodeAsync(metadata);

      // Create Decoder
      final decoder = ID3Decoder(encodedBytes);

      // Decode the newly encoded metadata
      final decoded = await decoder.decodeAsync();

      debugPrint(decoded.toString());

      if (decoded.isEmpty) {
        throw Exception("Failed to decode the encoded metadata");
      }

      final updatedSongFile = await songFile.writeAsBytes(encodedBytes);

      if (!await updatedSongFile.exists()) {
        throw Exception("Failed to update the song file");
      }

      // Update audio query
      final isUpdated =
          await ref.read(onAudioQueryProvider).scanMedia(updatedSongFile.path);

      if (isUpdated) {
        ref.invalidate(songsControllerProvider);
      }

      return isUpdated;
    });
  }
}
