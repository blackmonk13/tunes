import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
