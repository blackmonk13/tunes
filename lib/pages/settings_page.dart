import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/pages/about_page.dart';
import 'package:tunes/pages/privacy_policy_page.dart';
import 'package:tunes/pages/scan_filters.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart'
    show indexingControllerProvider, isarProvider;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(action),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }

  void _say(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final searchHistory = ref.watch(searchHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(FluentIcons.phone_24_regular),
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(FluentIcons.weather_sunny_24_regular),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(FluentIcons.weather_moon_24_regular),
                    label: Text('Dark'),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) {
                  ref
                      .read(themeControllerProvider.notifier)
                      .setTheme(selection.first);
                },
              ),
            ),
          ),
          const _SectionHeader('Library'),
          ListTile(
            leading: const Icon(FluentIcons.filter_24_regular),
            title: const Text('Scan filters'),
            subtitle: const Text('Choose which folders are scanned'),
            onTap: () {
              Navigator.of(context).push(routeTo(page: const ScanFilters()));
            },
          ),
          ListTile(
            leading: const Icon(FluentIcons.arrow_sync_24_regular),
            title: const Text('Rescan library'),
            subtitle: const Text('Look for new, changed and removed songs'),
            onTap: () {
              ref.invalidate(indexingControllerProvider);
              _say(context, 'Scanning the library');
            },
          ),
          const _SectionHeader('History'),
          ListTile(
            leading: const Icon(FluentIcons.search_24_regular),
            title: const Text('Clear search history'),
            subtitle: Text(
              searchHistory.isEmpty
                  ? 'No searches saved'
                  : '${searchHistory.length} saved '
                      '${searchHistory.length == 1 ? 'search' : 'searches'}',
            ),
            enabled: searchHistory.isNotEmpty,
            onTap: () async {
              await ref.read(searchHistoryProvider.notifier).clear();
              if (context.mounted) _say(context, 'Search history cleared');
            },
          ),
          ListTile(
            leading: const Icon(FluentIcons.history_24_regular),
            title: const Text('Reset play history'),
            subtitle: const Text('Sets every song back to never played'),
            onTap: () async {
              final isar = ref.read(isarProvider).requireValue;
              final confirmed = await _confirm(
                context,
                title: 'Reset play history?',
                message: 'Play counts and last played times are cleared for '
                    'every song. Recently played, Most played and Least '
                    'played start over.',
                action: 'Reset',
              );
              if (!confirmed) return;

              await resetPlayHistory(isar);
              if (context.mounted) _say(context, 'Play history reset');
            },
          ),
          const _SectionHeader('Information'),
          ListTile(
            leading: const Icon(FluentIcons.shield_24_regular),
            title: const Text('Privacy policy'),
            onTap: () {
              Navigator.of(context).push(
                routeTo(page: const PrivacyPolicyPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(FluentIcons.info_24_regular),
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).push(routeTo(page: const AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
