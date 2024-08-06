part of 'providers.dart';



@riverpod
class SongsSortOrder extends _$SongsSortOrder {
  @override
  ({SongsSortType sortType, Sort orderType}) build(
    SongQueryType queryType,
  ) {
    return (
      sortType: SongsSortType.modified,
      orderType: Sort.desc,
    );
  }

  void sort({SongsSortType? sortType, Sort? orderType}) {
    state = (
      sortType: sortType ?? state.sortType,
      orderType: orderType ?? state.orderType
    );
  }
}

@Riverpod(keepAlive: true)
class SongsFilterConfigs extends _$SongsFilterConfigs {
  @override
  ({Set<PathFilter> filterPaths}) build() {
    return (filterPaths: _prefsFilterPaths);
  }

  Set<PathFilter> get _prefsFilterPaths {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
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
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
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
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
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
    final prefs = ref.watch(sharedPreferencesProvider).requireValue;
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
FutureOr<Song?> songWithId(SongWithIdRef ref, String id) async {
  final intId = int.parse(id);

  return ref.watch(isarProvider).requireValue.songs.get(intId);
}

@riverpod
FutureOr<Song?> currentSongInfo(CurrentSongInfoRef ref) async {
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
  FutureOr<bool?> build(Song song) {
    return null;
  }

  Future<bool> encode(Map<String, dynamic> fields) async {
    bool isEncoded = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // `song.data` should be a path to the file
      final songFile = File(song.filePath);

      // Check if the file actually exists
      if (!await songFile.exists()) {
        debugPrint("File does not exist");
        isEncoded = false;
        throw Exception('File not found');
      }

      final mimeType = lookupMimeType(song.filePath);
      // TODO: Handle Picture for id3 and cover for mp4
      final isId3 = id3Mimes.contains(mimeType);
      final handler = AudioQuery.createCodecHandler(songFile.path);

      if (handler == null) {
        isEncoded = false;
        return false;
      }

      handler.updateMetadata(fields);

      await handler.applyMetadataChanges();

      // TODO: Reindex file

      isEncoded = true;

      return true;
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

@Riverpod(keepAlive: true)
FutureOr<({FileImage image, PaletteGenerator palette})?> thumbnailData(
  ThumbnailDataRef ref,
  String? thumbnail,
) async {
  if (thumbnail == null) {
    return null;
  }

  final thumbFile = File(thumbnail);

  if (!await thumbFile.exists()) {
    return null;
  }

  final thumbFileImage = FileImage(thumbFile);

  final palette = await PaletteGenerator.fromImageProvider(
    thumbFileImage,
  );

  return (image: thumbFileImage, palette: palette);
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
