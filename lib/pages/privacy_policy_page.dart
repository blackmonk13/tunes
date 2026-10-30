import 'package:flutter/material.dart';
import 'package:tunes/utils/extensions.dart';

/// What Tunes keeps on the device and what it asks for, in plain words.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _sections = <({String title, String body})>[
    (
      title: 'Short version',
      body: 'Tunes plays the music files on your device. It has no account, '
          'no ads and no analytics, and it does not send anything about you or '
          'your music anywhere.',
    ),
    (
      title: 'What Tunes keeps on your device',
      body: 'To work, Tunes keeps these on your device only:\n'
          '• An index of your songs, artists, albums and genres, built by '
          'reading the tags in your music files.\n'
          '• Your playlists and the labels you add to songs.\n'
          '• How many times and when you played each song, which fills the '
          'Recently played, Most played and Least played playlists.\n'
          '• Your recent searches.\n'
          '• The queue you were playing and where you stopped, so playback '
          'can continue after the app restarts.\n'
          '• Your settings, such as the theme and the scan filters.\n'
          '• Small copies of cover art, so lists load quickly.',
    ),
    (
      title: 'Permissions',
      body: 'Tunes asks for access to audio files and to files on the device '
          'so it can find your music, read its tags and cover art, and write '
          'tag and cover changes you make back to the file. It does not read '
          'anything else.',
    ),
    (
      title: 'Changes to your files',
      body: 'Tunes only changes a music file when you edit its tags or covers '
          'yourself.',
    ),
    (
      title: 'Sharing',
      body: 'Nothing is shared with the author or with anyone else. The only '
          'time the app leaves itself is when you open the source code link '
          'on the About page, which opens in your browser.',
    ),
    (
      title: 'Removing your data',
      body: 'In Settings you can clear the search history and reset the play '
          'history. Clearing the app\'s storage in Android settings, or '
          'uninstalling the app, removes everything Tunes keeps, including '
          'playlists and labels. Your music files are never deleted.',
    ),
    (
      title: 'Changes to this policy',
      body: 'If this changes, the new text ships with the app and the source '
          'repository shows what changed.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy policy')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          for (final section in _sections) ...[
            Text(
              section.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(section.body, style: context.textTheme.bodyMedium),
            const SizedBox(height: 24.0),
          ],
        ],
      ),
    );
  }
}
