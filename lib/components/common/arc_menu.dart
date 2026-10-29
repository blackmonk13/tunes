import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArcMenu extends HookWidget {
  final List<Widget> children;
  final double startAngle;
  final double endAngle;
  final double radius;
  final Widget Function(bool opened, AnimationController controller) child;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final MouseCursor? mouseCursor;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final bool mini;
  final ShapeBorder? shape;
  final bool isExtended;
  const ArcMenu({
    super.key,
    required this.children,
    required this.child,
    this.startAngle = -math.pi / 4,
    this.endAngle = math.pi / 4,
    this.radius = 100.0,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.mouseCursor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.mini = false,
    this.shape,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMenuOpen = useState<bool>(false);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    void toggleMenu() {
      if (isMenuOpen.value) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
      isMenuOpen.value = !isMenuOpen.value;
    }

    return SizedBox.square(
      dimension: radius * 2.5,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Radial Buttons
          ..._buildRadialButtons(animationController),
      
          // Central Button
          FloatingActionButton(
            tooltip: tooltip,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            splashColor: splashColor,
            mouseCursor: mouseCursor,
            elevation: elevation,
            focusElevation: focusElevation,
            hoverElevation: hoverElevation,
            highlightElevation: highlightElevation,
            disabledElevation: disabledElevation,
            mini: mini,
            shape: shape,
            isExtended: isExtended,
            onPressed: toggleMenu,
            child: child(isMenuOpen.value, animationController),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRadialButtons(AnimationController animationController) {
    List<Widget> buttons = [];
    final int numberOfBtns = children.length; // Number of buttons in the arc
    final double arcAngle = endAngle - startAngle; // Total arc angle
    final double angleStep =
        arcAngle / (numberOfBtns - 1); // Angle between buttons

    for (int i = 0; i < numberOfBtns; i++) {
      double angle = startAngle + i * angleStep;

      buttons.add(
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final curvedValue =
                Curves.easeInOutCirc.transform(animationController.value);
            final offset = Offset(
              radius * math.cos(angle) * curvedValue,
              radius * math.sin(angle) * curvedValue,
            );
            return Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: curvedValue,
                child: child,
              ),
            );
          },
          child: children[i],
        ),
      );
    }

    return buttons;
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: ArcMenu(
//             mini: true,
//             radius: 150.0,
//             startAngle: math.pi + math.pi / 16,
//             endAngle: math.pi * 1.5 * .95,
//             child: (opened, controller) {
//               if (opened) {
//                 return const Icon(Icons.close);
//               }
//               return const Icon(Icons.add);
//             },
//             children: List.generate(
//               3,
//               (index) => FloatingActionButton(
//                 onPressed: () {
//                   // Handle button click
//                   print("Clicked button $index");
//                 },
//                 child: Text(index.toString()),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
