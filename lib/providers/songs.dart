part of 'providers.dart';

@Riverpod(keepAlive: true)
OnAudioQuery onAudioQuery(OnAudioQueryRef ref) {
  return OnAudioQuery();
}

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
