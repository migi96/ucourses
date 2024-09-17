// course_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_state.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';

class CourseActions {
  static void showDeleteConfirmation(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text(
            AppTexts.confirm,
            style: Styles.style18,
            textAlign: TextAlign.center,
          ),
          content: const Text(
            AppTexts.courseDeletionConfirmation,
            style: Styles.style16,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              label: const Text(
                AppTexts.cancel,
                style: Styles.style14,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                BlocProvider.of<AdminCubit>(context).deleteCourse(courseId);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                AppTexts.delete,
                style: Styles.style14Red,
              ),
            ),
          ],
        );
      },
    );
  }

  static void filterCourses(BuildContext context, String enteredKeyword) {
    final currentState = BlocProvider.of<AdminCubit>(context).state;

    if (currentState is AdminCoursesLoaded) {
      List<Course> filteredCourses = currentState.courses
          .where((course) =>
              course.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // Here you should handle the state update depending on your state management solution
    } else {
      // Handle case where courses aren't loaded or other state conditions
    }
  }
}
