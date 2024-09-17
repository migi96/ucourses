import 'dart:math';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double progress; // Progress of the animation

  CirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Calculate the center of the canvas and the maximum radius
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2));

    // Draw a circle based on the progress
    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint when the animation updates
  }
}
