part of 'providers.dart';

enum SongQueryType {
  allSongs,
  songsForArtist,
  songsForAlbum,
  songsForGenre,
  songsForPlaylist,
}

@riverpod
class SongsSortOrder extends _$SongsSortOrder {
  @override
  ({SongSortType sortType, OrderType orderType}) build(
      SongQueryType queryType) {
    return (
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
    );
  }

  void sort({SongSortType? sortType, OrderType? orderType}) {
    state = (
      sortType: sortType ?? state.sortType,
      orderType: orderType ?? state.orderType
    );
  }
}

List<SongModel> sortSongs(
  List<SongModel> songs,
  ({OrderType orderType, SongSortType sortType}) songsSortOrder,
) {
  songs.sort((a, b) {
    switch (songsSortOrder.sortType) {
      case SongSortType.TITLE:
        return a.title.compareTo(b.title);
      case SongSortType.ARTIST:
        return (a.artist ?? "Unknown Artist")
            .compareTo(b.artist ?? "Unknown Artist");
      case SongSortType.ALBUM:
        return (a.album ?? "Unknown Album")
            .compareTo(b.album ?? "Unknown Album");
      case SongSortType.DURATION:
        return (a.duration ?? 0).compareTo(b.duration ?? 0);
      case SongSortType.DATE_ADDED:
        return (a.dateAdded ?? 0).compareTo(b.dateAdded ?? 0);
      case SongSortType.SIZE:
        return a.size.compareTo(b.size);
      case SongSortType.DISPLAY_NAME:
        return a.displayName.compareTo(b.displayName);
      default:
        return 0; // Default: no sorting
    }
  });

  if (songsSortOrder.orderType == OrderType.DESC_OR_GREATER) {
    songs = songs.reversed.toList();
  }

  return songs;
}

@Riverpod(keepAlive: true)
class SongsFilterConfigs extends _$SongsFilterConfigs {
  @override
  ({Set<PathFilter> filterPaths}) build() {
    return (filterPaths: _prefsFilterPaths);
  }

  Set<PathFilter> get _prefsFilterPaths {
    final filterPathsJsonList = prefs.getStringList(filterPathsPrefsKey);

    if (filterPathsJsonList == null) {
      return {};
    }

    final filterPathsList = filterPathsJsonList.map((fp) {
      return PathFilter.fromJson(json.decode(fp));
    });

    return filterPathsList.toSet();
  }

  Future<bool> addPath(PathFilter value) async {
    final filterPaths = state.filterPaths;
    final added = filterPaths.add(value);

    if (!added) {
      return false;
    }

    final filterPathsList = filterPaths.map(
      (e) {
        return json.encode(e.toJson());
      },
    ).toList();

    final prefsAdded = await prefs.setStringList(
      filterPathsPrefsKey,
      filterPathsList,
    );
    state = (filterPaths: filterPaths);
    return prefsAdded;
  }

  Future<bool> updatePath(PathFilter previous, PathFilter next) async {
    final filterPaths = state.filterPaths;
    final updated = filterPaths.map((filter) {
      return filter == previous ? next : filter;
    }).toSet();

    final filterPathsList = updated.map(
      (e) {
        return json.encode(e.toJson());
      },
    ).toList();

    final prefsUpdated = await prefs.setStringList(
      filterPathsPrefsKey,
      filterPathsList,
    );
    state = (filterPaths: updated);
    return state.filterPaths.contains(next) && prefsUpdated;
  }

  Future<bool> removePath(PathFilter value) async {
    final filterPaths = state.filterPaths;
    final removed = filterPaths.remove(value);

    if (removed == false) {
      return false;
    }
    final filterPathsList = filterPaths.map(
      (e) {
        return json.encode(e.toJson());
      },
    ).toList();

    final prefsUpdated = await prefs.setStringList(
      filterPathsPrefsKey,
      filterPathsList,
    );
    state = (filterPaths: filterPaths);
    return prefsUpdated;
  }
}

@riverpod
FutureOr<List<SongModel>> querySongs(QuerySongsRef ref) async {
  final songs = await ref.read(onAudioQueryProvider).querySongs();
  final filterConfigs = ref.watch(songsFilterConfigsProvider);

  if (filterConfigs.filterPaths.isEmpty) {
    return songs;
  }

  List<SongModel> filteredSongs = songs.where(
    (song) {
      // Apply path filters
      final pathMatch = filterConfigs.filterPaths.any(
        (filter) {
          if (!filter.enabled) {
            return false;
          }
          return filter.include
              ? song.data.contains(filter.path)
              : !song.data.contains(filter.path);
        },
      );
      return pathMatch;
    },
  ).toList();

  return filteredSongs;
}

@riverpod
class SongsController extends _$SongsController {
  @override
  FutureOr<List<SongModel>> build({
    SongQueryType queryType = SongQueryType.allSongs,
    String? query,
  }) async {
    final songsSortOrder = ref.watch(
      songsSortOrderProvider(
        queryType,
      ),
    );

    List<SongModel> songs;

    if (queryType == SongQueryType.songsForPlaylist && query != null) {
      songs = await ref.read(onAudioQueryProvider).queryAudiosFrom(
            AudiosFromType.PLAYLIST,
            query,
            sortType: SongSortType.DATE_ADDED,
            orderType: OrderType.DESC_OR_GREATER,
          );
      return sortSongs(songs, songsSortOrder);
    } else {
      songs = await ref.watch(querySongsProvider.future);
    }

    if (queryType == SongQueryType.allSongs || query == null) {
      return sortSongs(songs, songsSortOrder);
    }

    songs = songs.where((song) {
      switch (queryType) {
        case SongQueryType.songsForGenre:
          return song.genre?.toLowerCase().trim() == query.toLowerCase().trim();
        case SongQueryType.songsForAlbum:
          return song.album?.toLowerCase().trim() == query.toLowerCase().trim();
        case SongQueryType.songsForArtist:
          final artists = song.artist?.toLowerCase().trim().split(',') ?? [];
          final queryArtists = query.toLowerCase().trim().split(',');
          if (artists.isEmpty || queryArtists.isEmpty) {
            return false;
          }
          return artists.any((artist) {
            return queryArtists.contains(artist);
          });
        default:
          return true;
      }
    }).toList();

    return sortSongs(songs, songsSortOrder);
  }
}

@riverpod
FutureOr<Map<int, SongModel>> mappedSongs(MappedSongsRef ref) async {
  final songs = await ref.watch(querySongsProvider.future);

  return {for (var song in songs) song.id: song};
}

@riverpod
FutureOr<SongModel?> songWithId(SongWithIdRef ref, String id) async {
  final intId = int.parse(id);
  final songsMap = await ref.watch(mappedSongsProvider.future);

  return songsMap[intId];
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

  Future<bool> encodeSongMetadata(Map<String, dynamic> fields) async {
    bool isEncoded = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // `song.data` should be a path to the file
      final songFile = File(song.data);

      // Check if the file actually exists
      if (!await songFile.exists()) {
        debugPrint("File does not exist");
        isEncoded = false;
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
        isEncoded = false;
        throw Exception("Failed to decode the encoded metadata");
      }

      final updatedSongFile = await songFile.writeAsBytes(encodedBytes);

      if (!await updatedSongFile.exists()) {
        isEncoded = false;
        throw Exception("Failed to update the song file");
      }

      // Update audio query
      final isUpdated =
          await ref.read(onAudioQueryProvider).scanMedia(updatedSongFile.path);

      if (isUpdated) {
        isEncoded = true;
        ref.invalidate(querySongsProvider);
      }

      return isUpdated;
    });

    return isEncoded;
  }

  Future<bool> encodeMp4(Map<String, dynamic> fields) async {
    bool isEncoded = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // `song.data` should be a path to the file
      final songFile = File(song.data);

      // Check if the file actually exists
      if (!await songFile.exists()) {
        debugPrint("File does not exist");
        isEncoded = false;
        throw Exception('File not found');
      }

      final handler = MP4Handler(songFile.path);

      handler.updateMetadata(fields);

      await handler.applyMetadataChanges();

      // Update audio query
      final isUpdated =
          await ref.read(onAudioQueryProvider).scanMedia(songFile.path);

      if (isUpdated) {
        isEncoded = true;
        ref.invalidate(querySongsProvider);
      }

      return isUpdated;
    });

    return isEncoded;
  }
}

@riverpod
FutureOr<({Uint8List image, PaletteGenerator palette})?> artworkData(
  ArtworkDataRef ref,
  int id,
  ArtworkType type, {
  ArtworkFormat? format,
  int? size,
  int? quality,
}) async {
  final imageData = await ref.read(onAudioQueryProvider).queryArtwork(
        id,
        type,
        format: format,
        size: size,
        quality: quality,
      );

  if (imageData == null) {
    return null;
  }

  final palette = await PaletteGenerator.fromImageProvider(
    MemoryImage(imageData),
  );
  return (image: imageData, palette: palette);
}

@riverpod
FutureOr<File?> artworkFile(
  ArtworkFileRef ref,
  int id,
  ArtworkType type, {
  ArtworkFormat? format,
  int? size,
  int? quality,
}) async {
  final imageBytes = await ref.read(onAudioQueryProvider).queryArtwork(
        id,
        type,
        format: format,
        size: size,
        quality: quality,
      );

  if (imageBytes == null) {
    return null;
  }

  final appDocumentsDir = await getApplicationDocumentsDirectory();
  final artworkDir = Directory('${appDocumentsDir.path}/.artwork');

  if (!await artworkDir.exists()) {
    await artworkDir.create();
  }

  final artworkFile = File('${artworkDir.path}/$id.jpg');

  if (!await artworkFile.exists()) {
    await artworkFile.writeAsBytes(imageBytes);
  }

  return artworkFile;
}

@riverpod
MP4Handler mp4Handler(Ref ref, String filePath) {
  return MP4Handler(filePath);
}