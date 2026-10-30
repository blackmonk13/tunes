import 'package:tunes/utils/constants.dart';
import 'package:tunes/utils/media_query.dart' show Playlist;

extension PlaylistDisplayName on Playlist {
  /// The name to show. The favorites playlist is stored under a reserved name
  /// that a user playlist cannot clash with, so it is shown as "Favorites".
  String get displayName => name == favsPlaylistName ? 'Favorites' : name;
}
