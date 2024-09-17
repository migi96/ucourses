import 'package:flutter/material.dart';

import 'widget_exports.dart';

class AnimatedCircleContainer extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;

  const AnimatedCircleContainer({
    super.key,
    required this.child,
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  _AnimatedCircleContainerState createState() =>
      _AnimatedCircleContainerState();
}

class _AnimatedCircleContainerState extends State<AnimatedCircleContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 360, // Adjusted size to fit content
            height: 360, // Larger height to prevent overflow
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circle fade-in effect using CustomPaint
                CustomPaint(
                  size: const Size(360, 360), // Circular size for area
                  painter: CirclePainter(
                    progress:
                        _progressAnimation.value, // Progress of the animation
                  ),
                ),
                Opacity(
                  opacity: _progressAnimation.value,
                  child: widget.child,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
