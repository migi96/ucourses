// dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';

class Dialogs {
  static void showAddEditCourseDialog(BuildContext context, {Course? course}) {
    final TextEditingController imageController =
        TextEditingController(text: course?.images ?? '');
    final TextEditingController titleController =
        TextEditingController(text: course?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: course?.description ?? '');
    final TextEditingController contentController =
        TextEditingController(text: course?.content ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            alignment: Alignment.center,
            title:
                Text(course == null ? AppTexts.addCourse : AppTexts.editCourse),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: AppTexts.courseTitle)),
                  TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: AppTexts.courseDescripition)),
                  TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                          hintText: AppTexts.courseContent)),
                  TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                          hintText: AppTexts.courseImage)),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  final newCourse = Course(
                    id: course?.id ?? '',
                    title: titleController.text,
                    description: descriptionController.text,
                    content: contentController.text,
                    images: imageController.text,
                    rating: course?.rating ?? 0.0,
                    isArchived: course?.isArchived ?? false, // Add this
                    date: course?.date ?? DateTime.now(), // Add this
                    status: course?.status ?? 'draft', // Add this
                  );

                  if (course == null) {
                    BlocProvider.of<AdminCubit>(context).addCourse(newCourse);
                  } else {
                    BlocProvider.of<AdminCubit>(context).editCourse(newCourse);
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.save, color: Colors.green),
                label: Text(course == null ? AppTexts.add : AppTexts.save,
                    style: Styles.style16),
              ),
              ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  label: const Text(
                    AppTexts.cancel,
                    style: Styles.style14,
                  ))
            ],
          ),
        );
      },
    );
  }

  static void showDeleteConfirmation(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text(AppTexts.confirm),
          content: const Text(AppTexts.courseDeletionConfirmation),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppTexts.cancel),
            ),
            TextButton.icon(
              onPressed: () {
                BlocProvider.of<AdminCubit>(context).deleteCourse(courseId);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
              label: const Text(AppTexts.delete,
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
