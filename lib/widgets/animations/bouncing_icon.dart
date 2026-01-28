import 'package:flutter/material.dart';

class BouncingIcon extends StatefulWidget {
  final String emoji;
  final double fontSize;
  final Duration duration;

  const BouncingIcon({
    Key? key,
    required this.emoji,
    this.fontSize = 40,
    this.duration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  State<BouncingIcon> createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Text(
              widget.emoji,
              style: TextStyle(fontSize: widget.fontSize),
            ),
          ),
        );
      },
    );
  }
}