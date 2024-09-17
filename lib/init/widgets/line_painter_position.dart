// line_painter.dart
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final bool animateFromLeft;
  final double progressVertical;
  final double progressHorizontal;
  final double circleOpacity;

  LinePainter({
    required this.animateFromLeft,
    required this.progressVertical,
    required this.progressHorizontal,
    required this.circleOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 0.8;

    double startY = 50.0;
    double totalHeight = size.height - 100;
    double endY = startY + (totalHeight * progressVertical);

    canvas.drawLine(
      Offset(size.width / 2, startY),
      Offset(size.width / 2, endY),
      paint,
    );

    double lineLength = 350 * progressHorizontal;
    double dividingLineY = size.height / 2;
    double endX = animateFromLeft
        ? size.width / 2 - lineLength
        : size.width / 2 + lineLength;

    if (progressVertical > 0.6) {
      canvas.drawLine(
        Offset(size.width / 2, dividingLineY),
        Offset(endX, dividingLineY),
        paint,
      );
      canvas.drawCircle(Offset(endX, dividingLineY), 4.0,
          paint..color = Colors.white.withOpacity(circleOpacity));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
