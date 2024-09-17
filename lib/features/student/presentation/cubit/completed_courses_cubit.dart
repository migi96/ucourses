import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/course_model.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import 'completed_courses_state.dart';



class CompletedCoursesCubit extends Cubit<CompletedCoursesState> {
  final CourseRepository courseRepository;
  final String studentId; // Need to pass studentId to cubit

  CompletedCoursesCubit({required this.courseRepository, required this.studentId}) : super(CompletedCoursesInitial());

 Future<void> getCompletedCourses() async {
    emit(CompletedCoursesLoading());
    try {
      List<Course> courses = await courseRepository.getCompletedCourses(studentId);
      List<CourseModel> completedCourses = [];
      for (var course in courses) {
        var courseModel = CourseModel.fromCourse(course);
        print("Course: ${courseModel.title}, Score: ${courseModel.score}"); // Ensure score is correctly logged
        completedCourses.add(courseModel);
      }
      emit(CompletedCoursesLoaded(completedCourses));
    } catch (e) {
      print("Error during fetching: $e"); 
      emit(CompletedCoursesError("Failed to fetch completed courses: ${e.toString()}"));
    }
  }
}

