// Custom Painter to handle the white pixel drawing
import 'package:flutter/material.dart';

class PixelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    const int pixelSize = 10;

    // Draw pixelated squares for the clipping path
    for (double x = 0; x < size.width; x += pixelSize) {
      for (double y = 0; y < size.height; y += pixelSize) {
        path.addRect(
            Rect.fromLTWH(x, y, pixelSize.toDouble(), pixelSize.toDouble()));
      }
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // Reclip every time the animation changes
  }
}
