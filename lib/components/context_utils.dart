import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

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

BorderRadius get roundedTop {
  return const BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  );
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

  void showSnackBar({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    HeroIcons icon = HeroIcons.informationCircle,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: roundedTop,
        ),
        content: Row(
          children: [
            HeroIcon(
              icon,
              color: iconColor,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth * .7,
                    child: Text(
                      message,
                      style: textTheme.bodyMedium?.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? colorScheme.background,
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(
      message: message,
      iconColor: colorScheme.error,
      backgroundColor: colorScheme.errorContainer,
      icon: HeroIcons.exclamationTriangle,
    );
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
