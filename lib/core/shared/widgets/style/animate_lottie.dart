import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLottie extends StatefulWidget {
  final String animationPath;
  final bool isHovered;

  const AnimatedLottie({
    super.key,
    required this.animationPath,
    required this.isHovered,
  });

  @override
  _AnimatedLottieState createState() => _AnimatedLottieState();
}

class _AnimatedLottieState extends State<AnimatedLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(AnimatedLottie oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHovered) {
      _controller.forward();
    } else {
      _controller.stop();
      _controller.value = 0.0; // Reset to the start of the animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.animationPath,
      height: 90,
      width: 90,
      controller: _controller,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
