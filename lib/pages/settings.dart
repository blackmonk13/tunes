import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/floating_modal.dart';
import 'package:tunes/providers/main.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              tileColor: context.colorScheme.errorContainer.withOpacity(.5),
              leading: const HeroIcon(
                HeroIcons.circleStack,
              ),
              title: const Text("Reset Database"),
              onTap: () => showFloatingModalBottomSheet(
                context: context,
                builder: (context) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        HeroIcon(
                          HeroIcons.exclamationTriangle,
                          size: context.shortestSide * .18,
                          color: context.colorScheme.errorContainer
                              .withOpacity(.8),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: context.colorScheme.errorContainer
                                .withOpacity(.4),
                          ),
                          child: Text(
                            "This action is irreversible.",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const ListTile(
                          title: Text("Are you sure?"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlinedButton(
                              onPressed: () async {
                                await ref
                                    .read(tunesRepositoryProvider)
                                    .db
                                    .resetTunes();
                              },
                              child: const Text("Continue"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              child: const Text("Cancel"),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
            const AboutListTile(
              applicationName: 'Tunes',
              applicationLegalese: 'blackmonk13',
              applicationVersion: '1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}
