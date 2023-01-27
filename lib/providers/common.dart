part of providers;

@riverpod
FutureOr<List<String>> mediaPaths(Ref ref) {
  return getMediaPaths();
}

@Riverpod(keepAlive: true)
TunesDb database(Ref ref) {
  return TunesDb();
}

@Riverpod(keepAlive: true)
TunesRepository tunesRepository(TunesRepositoryRef ref) {
  final tunesRepo = TunesRepository(
    db: ref.watch(
      databaseProvider,
    ),
  );
  ref.onDispose(() => tunesRepo.dispose());
  return tunesRepo;
}