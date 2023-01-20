import 'package:flutter/material.dart';

List<Widget> headerList({
  Widget? title,
  Color? backgroundColor,
  required double itemExtent,
  required SliverChildDelegate delegate,
  List<Widget>? actions,
}) {
  return [
    SliverAppBar(
      title: title,
      primary: false,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      pinned: true,
      actions: actions,
    ),
    SliverFixedExtentList(
      itemExtent: itemExtent,
      delegate: delegate,
    )
  ];
}

extension ContextUtils on BuildContext {
  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  double get screenAspect {
    return MediaQuery.of(this).size.aspectRatio;
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get shortestSide {
    return MediaQuery.of(this).size.shortestSide;
  }

  double get longestSide {
    return MediaQuery.of(this).size.longestSide;
  }

  ColorScheme get colorScheme {
    return Theme.of(this).colorScheme;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  IconThemeData get iconTheme {
    return Theme.of(this).iconTheme;
  }
}

Route routeTo({required Widget page}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
