import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final bool animateFromLeft;
  final double progressVertical; // Progress for vertical line animation
  final double progressHorizontal; // Progress for horizontal line animation
  final double circleOpacity; // Opacity for circle fade animation

  LinePainter({
    required this.animateFromLeft,
    required this.progressVertical,
    required this.progressHorizontal,
    required this.circleOpacity, // Receive the fade animation progress
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 0.8;

    // Adjust these padding values to make the vertical line smaller at both ends
    double verticalPaddingTop = 50.0; // Padding from the top
    double verticalPaddingBottom = 50.0; // Padding from the bottom

    // Calculate the total height available for the vertical line after accounting for padding
    double totalHeight =
        size.height - verticalPaddingTop - verticalPaddingBottom;

    // Animate the main vertical line based on progress
    double startY =
        verticalPaddingTop; // Starting Y point is padded from the top
    double endY = startY +
        (totalHeight * progressVertical); // Vertical line grows with padding

    // Draw the animated vertical line (center of the screen)
    canvas.drawLine(
      Offset(size.width / 2, startY),
      Offset(size.width / 2, endY), // Line length is controlled by progress
      paint,
    );

    // Define how far the divided line should extend (e.g., 350 pixels)
    double lineLength = 350 *
        progressHorizontal; // Horizontal line grows based on horizontal progress

    // Set the Y coordinate at the center of the screen
    double dividingLineY = size.height / 2;

    // Calculate the X coordinate for the dividing line based on direction and progress
    double endX = animateFromLeft
        ? size.width / 2 - lineLength // Line moves left and stays short
        : size.width / 2 + lineLength; // Line moves right and stays short

    // Only draw the dividing line once the vertical line reaches the center (progressVertical > 0.6)
    if (progressVertical > 0.6) {
      canvas.drawLine(
        Offset(size.width / 2, dividingLineY),
        Offset(endX, dividingLineY), // Shorter horizontal line at the center Y
        paint,
      );

      // Draw a small solid circle at the end of the horizontal line with fade animation
      canvas.drawCircle(
        Offset(
            endX, dividingLineY), // Position at the end of the horizontal line
        4.0, // Radius of the circle
        paint..color = Colors.white.withOpacity(circleOpacity), // Fade effect
      );
    }

    // Draw circles at the top and bottom of the vertical line with fade animation
    if (progressVertical > 0.0) {
      canvas.drawCircle(
        Offset(
            size.width / 2, startY), // Position at the top of the vertical line
        4.0, // Radius of the circle
        paint..color = Colors.white.withOpacity(circleOpacity), // Fade effect
      );
    }

    if (progressVertical >= 1.0) {
      canvas.drawCircle(
        Offset(size.width / 2,
            endY), // Position at the bottom of the vertical line
        4.0, // Radius of the circle
        paint..color = Colors.white.withOpacity(circleOpacity), // Fade effect
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
