import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tunes/pages/home.dart';
import 'package:tunes/pages/scan_music.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

import 'pages/media_folders.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/scanmusic',
      builder: (context, state) => const ScanMusic(),
    ),
    GoRoute(
      path: '/musicfolders',
      builder: (context, state) => const MediaFolders(),
    ),
    
  ],
);

class TunesApp extends ConsumerWidget {
  const TunesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(databaseProvider);
    ref.listen(
      nowPlayingPlaylistProvider,
      (previous, current) async {
        if (current.audios.isEmpty) {
          player.stop();
          return;
        }

        final extraId = current.audios.indexWhere(
          (element) {
            if (previous == null) {
              return false;
            }
            return !previous.audios.contains(element);
          },
        );
        if (extraId <= 0) {
          player.playlistPlayAtIndex(extraId);
          return;
        }
        player.play();
      },
    );
    return MaterialApp.router(
      title: 'Tunes',
      // This theme was made for FlexColorScheme version 6.1.1. Make sure
      // you use same or higher version, but still same major version. If
      // you use a lower version, some properties may not be supported. In
      // that case you can also remove them after copying the theme to your app.
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xffff1744),
          primaryContainer: Color(0xffe49797),
          secondary: Color(0xff57c8d3),
          secondaryContainer: Color(0xff90f2fc),
          tertiary: Color(0xff69b9cd),
          tertiaryContainer: Color(0xffa6edff),
          appBarColor: Color(0xff90f2fc),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          inputDecoratorRadius: 20.0,
          popupMenuOpacity: 0.85,
          dialogRadius: 20.0,
          timePickerDialogRadius: 20.0,
          bottomSheetRadius: 20.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xffff1744),
          primaryContainer: Color(0xffd16768),
          secondary: Color(0xff9af3fc),
          secondaryContainer: Color(0xff67cdd7),
          tertiary: Color(0xffaeeeff),
          tertiaryContainer: Color(0xff77bfd1),
          appBarColor: Color(0xff67cdd7),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        appBarOpacity: 0.85,
        darkIsTrueBlack: true,
        surfaceTint: const Color(0xff000000),
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          inputDecoratorRadius: 20.0,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          popupMenuOpacity: 0.85,
          dialogRadius: 20.0,
          timePickerDialogRadius: 20.0,
          tabBarItemSchemeColor: SchemeColor.primary,
          tabBarIndicatorSchemeColor: SchemeColor.primary,
          bottomSheetRadius: 20.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
