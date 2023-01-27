import 'package:flutter/material.dart';

class AnimatedTextSwitcher extends StatefulWidget {
  final List<String> texts;
  final Duration duration;

  const AnimatedTextSwitcher({
    super.key,
    required this.texts,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State createState() => _AnimatedTextSwitcherState();
}

class _AnimatedTextSwitcherState extends State<AnimatedTextSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchText(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy > 0) {
      _currentIndex = (_currentIndex + 1) % widget.texts.length;
    } else {
      _currentIndex =
          (_currentIndex - 1 + widget.texts.length) % widget.texts.length;
    }
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: _switchText,
      child: Column(
        children: <Widget>[
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Text(widget.texts[_currentIndex]),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - _controller.value,
                child: Text(
                    widget.texts[(_currentIndex + 1) % widget.texts.length]),
              );
            },
          )
        ],
      ),
    );
  }
}
