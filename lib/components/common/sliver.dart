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

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxExt;
  final double minExt;

  StickyHeaderDelegate({
    required this.child,
    this.maxExt = 50.0,
    this.minExt = 50.0,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxExt; // Adjust this value as needed

  @override
  double get minExtent => minExt; // Adjust this value as needed

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
