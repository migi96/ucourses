import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';

class CourseSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Function clearSearchFunction;

  const CourseSearchWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.clearSearchFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppTexts.searchCourse,
            labelStyle: Styles.style16,
            prefix: const Icon(
              Icons.search,
              color: Colors.deepOrange,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => clearSearchFunction(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: onSubmitted,
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}
