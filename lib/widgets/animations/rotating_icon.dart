import 'package:flutter/material.dart';

class RotatingIcon extends StatefulWidget {
  final String emoji;
  final double fontSize;
  final Duration duration;

  const RotatingIcon({
    Key? key,
    required this.emoji,
    this.fontSize = 40,
    this.duration = const Duration(seconds: 20),
  }) : super(key: key);

  @override
  State<RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Text(
        widget.emoji,
        style: TextStyle(fontSize: widget.fontSize),
      ),
    );
  }
}