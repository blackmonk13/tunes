part of 'providers.dart';

@riverpod
class GenresController extends _$GenresController {
  @override
  FutureOr<List<GenreModel>> build() {
    return ref.read(onAudioQueryProvider).queryGenres();
  }
}

@riverpod
class GenreSongs extends _$GenreSongs {
  @override
  FutureOr<List<SongModel>> build(GenreModel genre) async {
    final allSongs = await ref.read(onAudioQueryProvider).querySongs(
          sortType: SongSortType.DATE_ADDED,
          orderType: OrderType.DESC_OR_GREATER,
        );

    final filteredSongs =
        allSongs.where((song) => song.genre == genre.genre).toList();
    return filteredSongs;
  }
}