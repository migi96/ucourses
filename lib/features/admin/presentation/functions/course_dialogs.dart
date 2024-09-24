// course_dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';

class CourseDialogs {
  // Existing add/edit course dialog
  static void showAddEditCourseDialog(BuildContext context, {Course? course}) {
    final TextEditingController imageController =
        TextEditingController(text: course?.images ?? '');
    final TextEditingController titleController =
        TextEditingController(text: course?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: course?.description ?? '');
    final TextEditingController contentController =
        TextEditingController(text: course?.content ?? '');
    final DateTime currentDate = course?.date ?? DateTime.now();

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
                  const SizedBox(height: 10),
                  Text(
                    'تاريخ الدورة: ${currentDate.toString()}',
                    style: Styles.style16.copyWith(fontWeight: FontWeight.bold),
                  ), // Display course date
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                  onPressed: () {
                    final newCourse = Course(
                      date: currentDate, // Ensure the date is passed here
                      id: course?.id ?? '',
                      title: titleController.text,
                      description: descriptionController.text,
                      content: contentController.text,
                      images: imageController.text,
                      rating: course?.rating ?? 0.0,
                      status: course?.status ?? '',
                      isArchived: course?.isArchived ?? false,
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

  // New delete confirmation dialog
  static void showDeleteConfirmation(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
                textAlign: TextAlign.center,
                'هل أنت متأكد؟',
                style: Styles.style14
                    .copyWith(fontSize: 19, fontWeight: FontWeight.bold)),
            content: Text(
                textAlign: TextAlign.center,
                'هل تريد حذف هذه الدورة؟ هذا الإجراء لا يمكن التراجع عنه.',
                style: Styles.style14.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
                label: Text(
                  textAlign: TextAlign.center,
                  'إلغاء',
                  style: Styles.style14
                      .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  context
                      .read<AdminCubit>()
                      .deleteCourse(courseId); // Call delete method
                  Navigator.of(context).pop(); // Close dialog after deletion
                },
                label: Text(
                  textAlign: TextAlign.center,
                  'حذف',
                  style: Styles.style14.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
