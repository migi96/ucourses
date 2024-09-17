import 'package:flutter/material.dart';

class ImagePositions extends StatelessWidget {
  final String imagePath;
  final double opacity;

  const ImagePositions({
    super.key,
    required this.imagePath,
    this.opacity = 0.05, // Default opacity value
  });

  @override
  Widget build(BuildContext context) {
    // Wrapping Stack in a SizedBox or Container to give finite size
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.03,
            child: _buildScaledImage(1.5, 8, context),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.width * 0.08,
            child: _buildScaledImage(2.0, 4, context),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildScaledImage(1.2, 5, context),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.20,
            child: _buildScaledImage(2.5, 5, context),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width * 0.28,
            child: _buildScaledImage(2.5, 11, context),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width * 0.7,
            child: _buildScaledImage(4.0, 23, context),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.6,
            left: MediaQuery.of(context).size.width * 0.9,
            child: _buildScaledImage(4.0, 18, context),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.8,
            child: _buildScaledImage(4.0, 11, context),
          ),
        ],
      ),
    );
  }

  Widget _buildScaledImage(double scale, int scaleValue, BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imagePath,
          scale: scaleValue.toDouble(),
        ),
      ),
    );
  }
}
