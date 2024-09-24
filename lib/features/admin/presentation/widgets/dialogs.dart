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

  static void showRestoreConfirmation(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            title: const Text(
              textAlign: TextAlign.center,
              'تأكيد الاستعادة',
              style: Styles.style18, // Use your custom Styles
            ),
            content: Text(
              textAlign: TextAlign.center,
              'هل أنت متأكد أنك تريد استعادة هذه الدورة؟',
              style: Styles.style16.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.normal), // Use your custom Styles
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
                label: Text(
                  textAlign: TextAlign.center,
                  'إلغاء',
                  style: Styles.style14.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.restore, color: Colors.white),
                onPressed: () {
                  context.read<AdminCubit>().restoreCourse(courseId);
                  Navigator.of(context).pop(); // Close dialog after action
                },
                label: Text(
                  textAlign: TextAlign.center,
                  'استعادة',
                  style: Styles.style16.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Permanent Delete Confirmation Dialog
  static void showPermanentDeleteConfirmation(
      BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            alignment: Alignment.center,
            title: Text(
              textAlign: TextAlign.center,
              'تأكيد الحذف النهائي',
              style: Styles.style18.copyWith(
                  color: Colors.red, fontSize: 20), // Use your custom Styles
            ),
            content: Text(
              textAlign: TextAlign.center,
              'هل أنت متأكد أنك تريد حذف هذه الدورة نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.',
              style: Styles.style16.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold), // Use your custom Styles
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
                label: Text(
                  textAlign: TextAlign.center,
                  'إلغاء',
                  style: Styles.style14.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  context.read<AdminCubit>().deleteCoursePermanently(courseId);
                  Navigator.of(context).pop(); // Close dialog after action
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
                label: Text(
                  textAlign: TextAlign.center,
                  'حذف نهائي',
                  style: Styles.style16.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
