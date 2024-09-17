import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import '../../../student/domain/entities/course_entity.dart';

class CourseDetailsContent extends StatelessWidget {
  final Course course;

  const CourseDetailsContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.title, color: Colors.deepOrange),
            SizedBox(width: 10),
            Text(AppTexts.courseTitle, style: Styles.style15grey),
          ],
        ),
        const SizedBox(height: 10),
        Text(course.title, style: Styles.style17),
        const SizedBox(height: 25),
        const Row(
          children: [
            Icon(Icons.description, color: Colors.deepOrange),
            SizedBox(width: 10),
            Text(AppTexts.courseDescripition, style: Styles.style15grey),
          ],
        ),
        const SizedBox(height: 10),
        Text(course.description, style: Styles.style17),
        const SizedBox(height: 25),
        const Row(
          children: [
            Icon(Icons.content_paste, color: Colors.deepOrange),
            SizedBox(width: 10),
            Text(AppTexts.courseContent, style: Styles.style15grey),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(course.content, style: Styles.style17),
        ),
      ],
    );
  }
}
