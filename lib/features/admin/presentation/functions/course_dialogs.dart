// course_dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';

class CourseDialogs {
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
                    decoration:
                        const InputDecoration(hintText: AppTexts.courseTitle),
                  ),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                        hintText: AppTexts.courseDescripition),
                  ),
                  TextField(
                    controller: contentController,
                    maxLines: 10,
                    minLines: 3,
                    decoration:
                        const InputDecoration(hintText: AppTexts.courseContent),
                  ),
                  TextField(
                    controller: imageController,
                    decoration:
                        const InputDecoration(hintText: AppTexts.courseImage),
                  ),
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
                    );
                    if (course == null) {
                      BlocProvider.of<AdminCubit>(context).addCourse(newCourse);
                    } else {
                      BlocProvider.of<AdminCubit>(context)
                          .editCourse(newCourse);
                    }
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.save, color: Colors.green),
                  label: Text(
                    course == null ? AppTexts.add : AppTexts.save,
                    style: Styles.style16,
                  )),
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
}
