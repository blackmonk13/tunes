part of 'providers.dart';



@riverpod
class SongsController extends _$SongsController {
  @override
  FutureOr<List<SongModel>> build() async {
    final allSongs = await ref.read(onAudioQueryProvider).querySongs(
          sortType: SongSortType.DATE_ADDED,
          orderType: OrderType.DESC_OR_GREATER,
        );

    final filteredSongs =
        allSongs.where((element) => element.fileExtension == "mp3").toList();
    return allSongs;
  }
}



@riverpod
class PlaylistsController extends _$PlaylistsController {
  @override
  FutureOr<List<PlaylistModel>> build() {
    return ref.read(onAudioQueryProvider).queryPlaylists();
  }
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
