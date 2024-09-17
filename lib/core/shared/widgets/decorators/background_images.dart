// lib/widgets/background_images.dart

import 'package:flutter/material.dart';

class PositionedImage extends StatelessWidget {
  final String imagePath;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  final double scale;
  final double opacity;

  const PositionedImage({
    super.key,
    required this.imagePath,
    this.top,
    this.left,
    this.bottom = 0.0,
    this.right = 0.0,
    required this.scale,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? 00,
      left: left,
      bottom: bottom,
      right: right,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            imagePath,
            scale: 5,
          ),
        ),
      ),
    );
  }
}
