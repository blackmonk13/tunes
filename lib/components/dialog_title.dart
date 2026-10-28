import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tunes/utils/extensions.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Text(
          title,
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          iconSize: 20.0,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            FluentIcons.dismiss_20_filled,
          ),
        ),
      ],
    );
  }
}
