import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const FloatingModal({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding,
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20.0),
}) async {
  final result = await showCustomModalBottomSheet(
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => FloatingModal(
      padding: padding,
      child: child,
    ),
    expand: false,
  );

  return result;
}
