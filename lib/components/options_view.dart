import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tunes/utils/extensions.dart';

class OptionsTile extends StatelessWidget {
  const OptionsTile({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.trailing = true,
  });
  final VoidCallback? onTap;
  final String title;
  final IconData? leading;
  final bool trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading == null
          ? null
          : Icon(
              leading,
            ),
      title: Text(
        title,
        style: context.textTheme.titleMedium,
      ),
      trailing: trailing
          ? Icon(
              FluentIcons.chevron_right_24_filled,
              size: context.textTheme.titleMedium?.fontSize,
              color: context.iconTheme.color?.withOpacity(.6),
            )
          : null,
    );
  }
}
