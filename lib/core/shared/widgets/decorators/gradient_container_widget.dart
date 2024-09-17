import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget? myChild;
  final double? myHeight;
  final double? myWidth;
  final Color firstGradientColor;
  final Color secondGradientColor;
  final Color? thirdGradientColor; // Optional third color
  final EdgeInsetsGeometry? padding; // Optional third color
  final BorderRadius? myContainerBorderRadius;
  final List<BoxShadow>? myShadow;

  const GradientContainer({
    super.key,
    this.myChild,
    this.myHeight,
    this.myWidth,
    required this.firstGradientColor,
    required this.secondGradientColor,
    this.thirdGradientColor, // Optional third color
    this.myContainerBorderRadius,
    this.myShadow,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: myHeight,
      width: myWidth,
      decoration: BoxDecoration(
        boxShadow: myShadow,
        borderRadius: myContainerBorderRadius,
        gradient: LinearGradient(
          begin: Alignment.topRight, // Start from the top-right corner
          end: Alignment.bottomLeft, // End at the bottom-left corner
          colors: _buildGradientColors(),
        ),
      ),
      child: myChild,
    );
  }

  List<Color> _buildGradientColors() {
    // If the third color is provided, include it in the gradient
    if (thirdGradientColor != null) {
      return [firstGradientColor, secondGradientColor, thirdGradientColor!];
    } else {
      return [firstGradientColor, secondGradientColor];
    }
  }
}
