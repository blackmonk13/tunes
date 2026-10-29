import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tunes/pages/scan_filters.dart';
import 'package:tunes/utils/extensions.dart';

class OptionsView extends StatelessWidget {
  const OptionsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        // top: 16.0,
        left: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  FluentIcons.options_24_regular,
                  size: context.textTheme.headlineSmall?.fontSize,
                  color: context.iconTheme.color?.withOpacity(.8),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  "Options",
                  style: context.textTheme.headlineSmall?.copyWith(
                      color: context.textTheme.headlineSmall?.color
                          ?.withOpacity(.8)),
                ),
              ],
            ),
          ),
          const Divider(),
          OptionsTile(
            onTap: () {},
            title: "Settings",
          ),
          OptionsTile(
            onTap: () {
              Navigator.of(context).push(
                routeTo(
                  page: const ScanFilters(),
                ),
              );
            },
            title: "Filters",
          ),
          OptionsTile(
            onTap: () {},
            title: "Privacy Policy",
          ),
          OptionsTile(
            onTap: () {},
            title: "About",
          ),
        ],
      ),
    );
  }
}

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
