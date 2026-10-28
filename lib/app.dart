import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/pages/home_page.dart';
import 'package:tunes/providers/providers.dart';

/// Widget class to manage asynchronous app initialization
class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. eagerly initialize appStartupProvider (and all the providers it depends on)
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      // 3. loading state
      loading: () => const AppStartupLoadingWidget(),
      // 4. error state
      error: (error, stackTrace) => AppStartupErrorWidget(
        error: error, stackTrace: stackTrace,
        // 5. invalidate the appStartupProvider
        onRetry: () => ref.refresh(appStartupProvider.future),
      ),
      // 6. success - now load the main app
      data: (_) => const HomePage(),
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.onRetry,
  });
  final Object? error;
  final StackTrace? stackTrace;
  final RefreshCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AsyncErrorView(
        error: error,
        stackTrace: stackTrace,
        onRefresh: onRetry,
      ),
    );
  }
}

class TunesApp extends ConsumerWidget {
  const TunesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Layout(
      child: MaterialApp(
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
        home: const AppStartupWidget(),
      ),
    );
  }
}
