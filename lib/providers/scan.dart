part of 'providers.dart';

@riverpod
class AudioFileController extends _$AudioFileController {
  @override
  FutureOr<int> build(File file) {
    return getAudioInfo();
  }

  String cleanName(String? name, {String? substitute}) {
    if (name == null) {
      return substitute ?? 'Unknown';
    }

    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return substitute ?? 'Unknown';
    }

    return trimmed;
  }

  FutureOr<int> getAudioInfo() async {
    final String filePath = file.path;
    Tag? tags;
    // Read tags from the audio file
    final tagMap = await tagger.readTagsAsMap(path: filePath);
    if (tagMap != null) {
      tags = Tag.fromMap(tagMap);
    }

    final artistId = await getArtist(tags?.artist ?? tags?.albumArtist);
    final albumId = await getAlbum(tags?.album, tags?.albumArtist);

    final title = cleanName(
      tags?.title,
      substitute: basenameWithoutExtension(filePath),
    );

    final songComp = SongsCompanion.insert(
      pathname: filePath,
      modified: file.lastModifiedSync(),
      title: Value(title),
      album: Value(albumId),
      artist: Value(artistId),
    );
    
    return ref.read(databaseProvider).songsDao.addSong(songComp);
  }

  FutureOr<int> getArtist(String? name) {
    final cleanedName = cleanName(name);
    final artistComp = ArtistsCompanion.insert(
      name: Value(cleanedName),
    );

    return ref.read(databaseProvider).artistsDao.addArtist(artistComp);
  }

  FutureOr<int> getAlbum(String? name, String? artistName) async {
    final cleanedName = cleanName(name);
    final artistId = await getArtist(artistName);
    final albumComp = AlbumsCompanion.insert(
      name: Value(cleanedName),
      artist: Value(artistId),
    );

    return ref.read(databaseProvider).albumsDao.addAlbum(albumComp);
  }
}

@riverpod
class AudioPathsWatcher extends _$AudioPathsWatcher {
  @override
  FutureOr<void> build() {
    return watchAudioPaths();
  }

  Future<void> watchAudioPaths() async {
    final audioPaths = await ref.watch(audioPathsProvider.future);

    final futures = audioPaths.map(
      (path) {
        return watchPath(path);
      },
    ).toList();

    await Future.wait(futures);
    return;
  }

  Future<void> watchPath(String audioPath) async {
    final directory = Directory(audioPath);

    // Start watching the directory for changes
    final Stream<FileSystemEvent> stream = directory.watch(
      recursive: true,
    );

    // Listen for events
    await for (FileSystemEvent event in stream) {
      debugPrint('Path: ${event.path}, Type: ${event.type}');
    }
  }
}

@riverpod
class ScanController extends _$ScanController {
  @override
  FutureOr<List<int>> build() {
    return scanMusic();
  }

  Future<void> runScan() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => scanMusic());
  }

  Future<List<int>> scanMusic() async {
    final audioFiles = await scanForAudioFiles();
    return Future.wait(
      audioFiles.map(
        (audioFile) {
          return ref.read(
            audioFileControllerProvider(
              (audioFile as File),
            ).future,
          );
        },
      ),
    );
  }

  Future<List<FileSystemEntity>> scanForAudioFiles() async {
    final audioPaths = await ref.watch(audioPathsProvider.future);

    List<Future<List<FileSystemEntity>>> futures = audioPaths.map(
      (path) {
        return scanDirectoryForAudioFiles(path);
      },
    ).toList();

    List<List<FileSystemEntity>> results = await Future.wait(futures);

    return results.expand(
      (files) {
        return files;
      },
    ).toList();
  }

  Future<List<FileSystemEntity>> scanDirectoryForAudioFiles(
    String dirPath,
  ) async {
    final dir = Directory(dirPath);
    final entities = dir.list(
      recursive: true,
    );

    final List<FileSystemEntity> audioFiles = [];

    await for (FileSystemEntity entity in entities) {
      if (entity is File) {
        if (isAudioFile(entity)) {
          audioFiles.add(entity);
        }
      }
    }

    return audioFiles;
  }
}

bool isAudioFile(FileSystemEntity file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType?.startsWith('audio/') == true;
}
