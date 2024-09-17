import 'dart:ui';
import 'package:flutter/material.dart';

class DotAndLinesPainter extends CustomPainter {
  final double progress;

  DotAndLinesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    // Center dot where lines will originate
    final center = Offset(size.width / 2.5, size.height / 2);

    // Draw the center dot
    canvas.drawCircle(center, 5.0, paint..style = PaintingStyle.fill);

    // Calculate the positions for the service containers
    final positions = [
      Offset(size.width * 0.15, size.height * 0.2), // Top-left for Service One
      Offset(size.width * 0.85, size.height * 0.2), // Top-right for Service Two
      Offset(size.width * 0.85,
          size.height * 0.7), // Bottom-right for Service Three
    ];

    // Scale factor for shortening the lines (adjust this value to make the lines shorter or longer)
    const double lineLengthScale =
        0.6; // Set this to a value between 0.0 and 1.0 (e.g., 0.6 means the line is 60% of the full length)

    // Loop through the positions and draw lines
    for (var position in positions) {
      // Calculate the scaled end point (making the lines shorter by using lineLengthScale)
      final endPoint = Offset(
        lerpDouble(center.dx, position.dx,
            progress * lineLengthScale)!, // Shorten the X distance
        lerpDouble(center.dy, position.dy,
            progress * lineLengthScale)!, // Shorten the Y distance
      );

      // Draw the line from the center to the shortened end point
      canvas.drawLine(center, endPoint, paint);

      // Draw a small circle at the end of each line
      canvas.drawCircle(
          endPoint, 10.0 * progress, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
