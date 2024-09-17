import 'package:flutter/material.dart';

class LowerWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Adjustments to make the wave smaller
    path.lineTo(0,
        size.height - 5); // Start the path closer to the top of the container

    // Smaller wave control points and end points
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 100, // Lower control point
      size.width / 2,
      size.height - 60, // Same height as start point
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 30, // Higher control point
      size.width,
      size.height - 200, // Same height as start point
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
