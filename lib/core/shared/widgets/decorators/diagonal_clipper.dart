import 'package:flutter/material.dart';

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the top right corner
    path.moveTo(size.width, 0);

    // Line to the top left corner (but lower down by a fraction of the height, for the diagonal effect)
    path.lineTo(0, size.height * 0.9);

    // Line to the bottom left corner
    path.lineTo(0, size.height);

    // Line to the bottom right corner
    path.lineTo(size.width, size.height);

    // Close the path to return to the starting point
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Return true if your clipper needs to reclip when the oldClipper changes
    return true;
  }
}
