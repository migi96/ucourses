import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';

class LogoShadow extends StatelessWidget {
  final String logoImage;
  final String companyName;

  final double? height;
  final double? width;

  const LogoShadow({
    super.key,
    required this.logoImage,
    required this.companyName,
    this.height = 55.0, // Default height if not provided
    this.width = 55.0, // Default width if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 40,
            child: Image.asset(
              logoImage,
              height: height,
              width: width,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          companyName,
          style: Styles.style15grey,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
