import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tunes/pages/privacy_policy_page.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

const _repositoryUrl = 'https://github.com/blackmonk13/tunes';

class AboutPage extends HookConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = useFuture(useMemoized(PackageInfo.fromPlatform)).data;
    final version = packageInfo == null
        ? ''
        : 'Version ${packageInfo.version} (${packageInfo.buildNumber})';

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        children: [
          const SizedBox(height: 24.0),
          Center(
            // The icon is a black glyph, so it sits on a light tile that shows
            // in both themes.
            child: Container(
              width: 112.0,
              height: 112.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: Image.asset('assets/icons/icon.png'),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Tunes',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            version,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Text(
              'A local music player for Android. It plays the music already '
              'on your device, with no account and no internet needed.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FluentIcons.code_24_regular),
            title: const Text('Source code'),
            subtitle: const Text(_repositoryUrl),
            onTap: () async {
              final opened = await launchUrl(
                Uri.parse(_repositoryUrl),
                mode: LaunchMode.externalApplication,
              );
              if (!opened && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open the link')),
                );
              }
            },
          ),
          const ListTile(
            leading: Icon(FluentIcons.person_24_regular),
            title: Text('Author'),
            subtitle: Text('blackmonk13'),
          ),
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
            leading: const Icon(FluentIcons.document_24_regular),
            title: const Text('Licenses'),
            subtitle:
                const Text('Tunes is GPL-3.0. Open source licenses used.'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Tunes',
                applicationVersion: packageInfo?.version,
                applicationLegalese: 'Licensed under the GNU GPL v3',
              );
            },
          ),
        ],
      ),
    );
  }
}
