part of 'providers.dart';

@riverpod
Stream<void> labelsWatcher(LabelsWatcherRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return isar.labels.watchLazy(fireImmediately: true);
}

@riverpod
Future<List<Label>> labels(LabelsRef ref) async {
  ref.watch(labelsWatcherProvider);
  final isar = ref.watch(isarProvider).requireValue;
  return isar.labels.where().sortByName().findAll();
}

/// The ids of the labels attached to the song with [songId].
@riverpod
Future<Set<int>> songLabelIds(SongLabelIdsRef ref, int songId) async {
  ref.watch(labelsWatcherProvider);
  final isar = ref.watch(isarProvider).requireValue;
  final song = await isar.songs.get(songId);
  if (song == null) return {};

  await song.labels.load();
  return song.labels.map((label) => label.id).toSet();
}

/// The labels attached to the song with [songId], sorted by name.
@riverpod
Future<List<Label>> songLabels(SongLabelsRef ref, int songId) async {
  ref.watch(labelsWatcherProvider);
  final isar = ref.watch(isarProvider).requireValue;
  final song = await isar.songs.get(songId);
  if (song == null) return [];

  await song.labels.load();
  return song.labels.toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}

@riverpod
class LabelsController extends _$LabelsController {
  @override
  void build() {}

  /// Creates a label called [name], or returns the existing one with the same
  /// name (ignoring case). Returns null when [name] is blank.
  Future<Label?> create(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final isar = ref.read(isarProvider).requireValue;
    return isar.writeTxn(() async {
      final existing = await isar.labels
          .filter()
          .nameEqualTo(trimmed, caseSensitive: false)
          .findFirst();
      if (existing != null) return existing;

      final label = Label()..name = trimmed;
      await isar.labels.put(label);
      return label;
    });
  }

  /// Replaces the labels on [song] with the labels in [labelIds].
  Future<void> setSongLabels(Song song, Set<int> labelIds) async {
    final isar = ref.read(isarProvider).requireValue;
    final selected = await isar.labels.getAll(labelIds.toList());

    await isar.writeTxn(() async {
      await song.labels.load();
      song.labels
        ..clear()
        ..addAll(selected.whereType<Label>());
      await song.labels.save();
    });

    // Changing links may not wake the labels watcher, so refresh explicitly.
    ref.invalidate(songLabelsProvider(song.id));
    ref.invalidate(songLabelIdsProvider(song.id));
  }

  Future<bool> delete(int labelId) async {
    final isar = ref.read(isarProvider).requireValue;
    return isar.writeTxn(() => isar.labels.delete(labelId));
  }
}
