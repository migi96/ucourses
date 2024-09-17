import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../student/domain/repositories/course_repository.dart';
import '../../../student/presentation/cubit/completed_courses_cubit.dart';
import 'completed_courses_screen.dart';

class CompletedCoursesPage extends StatelessWidget {
  final String studentId; // Assume you pass this through the constructor

  const CompletedCoursesPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    // Provide the CompletedCoursesCubit with the studentId
    return BlocProvider(
      create: (_) => CompletedCoursesCubit(
        courseRepository: RepositoryProvider.of<CourseRepository>(context),
        studentId: studentId,
      ),
      child: CompletedCoursesScreen(studentId: studentId),  // Correctly pass the studentId
    );
  }
}
