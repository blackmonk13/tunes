import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

/// A built-in playlist that fills itself from the play history.
enum SmartPlaylistKind {
  recentlyPlayed,
  mostPlayed,
  leastPlayed;

  String get title => switch (this) {
        recentlyPlayed => 'Recently played',
        mostPlayed => 'Most played',
        leastPlayed => 'Least played',
      };

  String get description => switch (this) {
        recentlyPlayed => 'Songs you played last',
        mostPlayed => 'The songs you play the most',
        leastPlayed => 'Songs you rarely or never play',
      };

  IconData get icon => switch (this) {
        recentlyPlayed => FluentIcons.history_24_regular,
        mostPlayed => FluentIcons.arrow_trending_24_regular,
        leastPlayed => FluentIcons.arrow_trending_down_24_regular,
      };
}

/// How many songs a smart playlist holds.
const smartPlaylistLength = 100;
