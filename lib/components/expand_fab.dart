import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum ExpandDirection {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
}

class ExpandableFab extends HookWidget {
  final bool isOpen;
  final double radius;
  final List<Widget> children;
  final Color? openBtnColor;
  final bool mini;
  final double spread;
  final ExpandDirection direction;
  final Widget Function(bool opened, AnimationController controller) child;

  const ExpandableFab({
    super.key,
    required this.child,
    required this.children,
    this.radius = 100.0,
    this.isOpen = false,
    this.openBtnColor,
    this.mini = false,
    this.spread = 90.0,
    this.direction = ExpandDirection.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    final open = useState<bool>(isOpen);
    final controller = useAnimationController(
      initialValue: isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
    );

    void toggle() {
      if (open.value) {
        controller.reverse();
      } else {
        controller.forward();
      }
      open.value = !open.value;
    }

    return SizedBox.square(
      dimension: radius * 2,
      child: Stack(
        alignment: alignment,
        clipBehavior: Clip.none,
        children: [
          ..._buildActionBtns(controller,),
          AnimatedContainer(
            transformAlignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
              open.value ? 0.8 : 1.0,
              open.value ? 0.8 : 1.0,
              1.0,
            ),
            duration: const Duration(milliseconds: 250),
            curve: const Interval(
              0.0,
              0.5,
              curve: Curves.easeOut,
            ),
            child: AnimatedOpacity(
              opacity: open.value ? 1.0 : 1.0,
              curve: const Interval(
                0.25,
                1.0,
                curve: Curves.easeInOut,
              ),
              duration: const Duration(milliseconds: 250),
              child: FloatingActionButton(
                mini: mini,
                onPressed: toggle,
                child: child(open.value, controller),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildActionBtns(AnimationController controller) {
    final children = <Widget>[];
    final count = children.length;
    final step = spread / (count - 1);

    final progress = CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeOutQuad,
      );
    
    for (var i = 0, angleInDegrees = expandAngle;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        ExpandingActionBtn(
          directionInDegrees: angleInDegrees,
          maxDistance: radius,
          progress: progress,
          expandDirection: direction,
          child: children[i],
        ),
      );
    }
    return children;
  }

  AlignmentGeometry get alignment {
    switch (direction) {
      case ExpandDirection.bottomLeft:
        return Alignment.topRight;
      case ExpandDirection.bottomRight:
        return Alignment.topLeft;
      case ExpandDirection.topRight:
        return Alignment.bottomLeft;
      default:
        return Alignment.bottomRight;
    }
  }

  double get expandAngle {
    switch (direction) {
      case ExpandDirection.topLeft:
        return 0.0;
      case ExpandDirection.topRight:
        return 90.0;
      case ExpandDirection.bottomRight:
        return 180.0;
      case ExpandDirection.bottomLeft:
        return 270.0;
      default:
        return 0.0;
    }
  }
}

class ExpandingActionBtn extends StatelessWidget {
  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  final ExpandDirection expandDirection;

  const ExpandingActionBtn({
    super.key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.expandDirection,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        final vOffset = 4.0 + offset.dy;
        final hOffset = 4.0 + offset.dx;
        return Positioned(
          right: rightOffset(hOffset),
          left: leftOffset(hOffset),
          top: topOffset(vOffset),
          bottom: bottomOffset(vOffset),
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }

  double? topOffset(double vOffset) {
    switch (expandDirection) {
      case ExpandDirection.bottomLeft:
        return -vOffset;
      case ExpandDirection.bottomRight:
        return -vOffset;
      case ExpandDirection.topRight:
        return null;
      default:
        return null;
    }
  }

  double? bottomOffset(double vOffset) {
    switch (expandDirection) {
      case ExpandDirection.bottomLeft:
        return null;
      case ExpandDirection.bottomRight:
        return null;
      case ExpandDirection.topRight:
        return vOffset;
      default:
        return vOffset;
    }
  }

  double? leftOffset(double hOffset) {
    switch (expandDirection) {
      case ExpandDirection.bottomLeft:
        return null;
      case ExpandDirection.bottomRight:
        return -hOffset;
      case ExpandDirection.topRight:
        return -hOffset;
      default:
        return null;
    }
  }

  double? rightOffset(double hOffset) {
    switch (expandDirection) {
      case ExpandDirection.bottomLeft:
        return hOffset;
      case ExpandDirection.bottomRight:
        return null;
      case ExpandDirection.topRight:
        return null;
      default:
        return hOffset;
    }
  }
}
