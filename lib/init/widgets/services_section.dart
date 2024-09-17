import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';

class ServicesSection extends StatefulWidget {
  final String serviceImage;
  final String title;
  final String description;
  const ServicesSection(
      {super.key,
      required this.serviceImage,
      required this.title,
      required this.description});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          maxRadius: 70,
          child: Image.asset(
            widget.serviceImage,
            height: 80,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.title,
          style: Styles.style18,
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          widget.description,
          style: Styles.style16,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
