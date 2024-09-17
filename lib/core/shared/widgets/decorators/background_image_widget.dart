import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final Widget child;

  // Optional parameters for customization
  final String imagePath;
  final BoxFit fit;
  final double opacity;

  const BackgroundImageWidget({
    super.key,
    required this.child,
    this.imagePath =
        'lib/assets/images/style/t_background.png', // Default image path
    this.fit = BoxFit.cover,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: fit,
              ),
            ),
          ),
        ),
        // Foreground Child
        child,
      ],
    );
  }
}
