import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/prefs.dart';

import 'app.dart';



Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.blackmonk13.tunes.channel.audio',
    androidNotificationChannelName: 'Tunes',
    androidNotificationOngoing: true,
  );
  prefs = await SharedPreferences.getInstance();

  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    const ProviderScope(
      child: TunesApp(),
    ),
  );
}
