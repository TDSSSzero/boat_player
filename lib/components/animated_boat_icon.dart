import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBoatIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final bool isAnimating;

  const AnimatedBoatIcon({
    super.key,
    required this.icon,
    this.size = 24.0,
    this.color = Colors.white,
    this.isAnimating = false,
  });

  @override
  State<AnimatedBoatIcon> createState() => _AnimatedBoatIconState();
}

class _AnimatedBoatIconState extends State<AnimatedBoatIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    if (widget.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBoatIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0);
      }
    }
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
        return Transform.rotate(
          angle: math.sin(_controller.value * 2 * math.pi) * 0.05,
          child: child,
        );
      },
      child: Icon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}
