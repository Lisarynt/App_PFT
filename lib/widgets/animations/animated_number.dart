import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class AnimatedNumber extends StatelessWidget {
  final double value;
  final TextStyle style;
  final Duration duration;
  final bool isCurrency;

  const AnimatedNumber({
    Key? key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.isCurrency = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, animatedValue, child) {
        return Text(
          isCurrency 
              ? Helpers.formatCurrency(animatedValue)
              : animatedValue.toStringAsFixed(0),
          style: style,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}