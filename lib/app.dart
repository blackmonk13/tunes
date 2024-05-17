import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:tunes/pages/home_page.dart';
import 'package:tunes/providers/providers.dart';

class TunesApp extends ConsumerWidget {
  const TunesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appPermissionsProvider, (previous, next) {});
    return MaterialApp(
      title: 'Tunes',
       theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xFFFF1744),
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
        // fontFamily: GoogleFonts.inter().fontFamily,
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
        // fontFamily: GoogleFonts.inter().fontFamily,
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
