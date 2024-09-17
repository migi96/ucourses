import 'package:flutter/material.dart';

class DottedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from top left
    path.moveTo(0, 0);

    // Create a wavy rounded path at the top with curves instead of sharp edges
    for (double i = 0; i < size.width; i += 20) {
      path.quadraticBezierTo(
          i + 5, 15, i + 10, 0); // Curve up for smooth rounded edge
    }

    // Draw lines for the sides
    path.lineTo(size.width, size.height);

    // Create a wavy rounded path at the bottom with curves instead of sharp edges
    for (double i = size.width; i > 0; i -= 20) {
      path.quadraticBezierTo(i - 5, size.height - 15, i - 10,
          size.height); // Curve down for smooth rounded edge
    }

    path.lineTo(0, size.height); // Complete the rectangle
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
