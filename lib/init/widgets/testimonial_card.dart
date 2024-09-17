import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import '../../core/constants/constants_exports.dart';
import 'testimonial_item.dart'; // Ensure this import points to the correct file

class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;
  final double width;
  final double height;

  const TestimonialCard({
    super.key,
    required this.testimonial,
    this.width = 350, // Default width if not specified
    this.height = 400, // Default height if not specified
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            child: Icon(
              testimonial.icon,
              size: 60,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: AppColors.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  testimonial.name,
                  style: Styles.style20White,
                ),
                const SizedBox(height: 10),
                Text(
                  testimonial.major,
                  style: Styles.style16White,
                ),
                const SizedBox(height: 10),
                Text(
                  testimonial.testimonial,
                  textAlign: TextAlign.center,
                  style: Styles.style14Light,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
