import 'package:flutter/material.dart';

class JoinBtn {
  final IconData? icon;
  final String? label;
  final VoidCallback? onPressed;

  JoinBtn({
    this.icon,
    this.label,
    required this.onPressed,
  }) : assert(
          icon != null || label != null,
          'You must provide an icon or a label.',
        );
}

class JoinBtns extends StatelessWidget {
  final List<JoinBtn> buttons;
  final MainAxisAlignment mainAxisAlignment;
  final Color? color;
  final double? elevation;
  final double? height;
  final TextStyle? textStyle;

  const JoinBtns({
    super.key,
    required this.buttons,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.color,
    this.elevation,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final btnHeight = height ?? Theme.of(context).buttonTheme.height;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: elevation,
      color: color,
      child: SizedBox(
        height: btnHeight,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: buttons.expand((button) {
            return [
              Expanded(
                child: InkWell(
                  onTap: button.onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (button.icon != null) Icon(button.icon),
                        const SizedBox(
                          width: 8.0,
                        ),
                        if (button.label != null)
                          Text(
                            button.label ?? "",
                            style: const TextStyle(
                              // fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ).merge(textStyle),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (button != buttons.last)
                Container(
                  width: 1.0,
                  height: btnHeight * .5,
                  color: Theme.of(context).dividerColor.withOpacity(.5),
                ),
            ];
          }).toList(),
        ),
      ),
    );
  }
}
