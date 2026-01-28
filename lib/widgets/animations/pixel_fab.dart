import 'package:flutter/material.dart';

class PixelFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final double size;

  const PixelFAB({
    Key? key,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFFF6B6B),
    this.iconColor = Colors.white,
    this.icon = Icons.add,
    this.size = 56,
  }) : super(key: key);

  @override
  State<PixelFAB> createState() => _PixelFABState();
}

class _PixelFABState extends State<PixelFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 3),
                ),
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    alignment: Alignment.center,
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}