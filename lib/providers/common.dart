part of providers;

final mediaPathsProvider = FutureProvider<List<String>>(
  (ref) async {
    final mediaPaths = await getMediaPaths();
    return mediaPaths;
  },
);
