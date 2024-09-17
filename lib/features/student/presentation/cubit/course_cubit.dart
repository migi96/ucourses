import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/course_use_cases.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseUseCases courseUseCases;

  CourseCubit(this.courseUseCases) : super(CourseInitial());

  Future<void> getCourses() async {
    emit(CourseLoading());
    try {
      var courses = await courseUseCases.getCourses();
      print("Courses fetched successfully with count: ${courses.length}");  // Log the success and count of courses
      emit(CourseLoaded(courses));
    } catch (e) {
      print("Failed to load courses from Firestore: $e");  // Log the error
      emit(const CourseError('Failed to load courses'));
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      await courseUseCases.addCourse(course);
      print("Course added successfully");  // Log successful addition
      getCourses();
    } catch (e) {
      print("Failed to add course: $e");  // Log error on addition
      emit(const CourseError('Failed to add course'));
    }
  }

  Future<void> editCourse(String courseId, Course course) async {
    try {
      await courseUseCases.editCourse(courseId, course);
      print("Course edited successfully");  // Log successful edit
      getCourses();
    } catch (e) {
      print("Failed to edit course: $e");  // Log error on edit
      emit(const CourseError('Failed to edit course'));
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      await courseUseCases.deleteCourse(courseId);
      print("Course deleted successfully");  // Log successful deletion
      getCourses();
    } catch (e) {
      print("Failed to delete course: $e");  // Log error on deletion
      emit(const CourseError('Failed to delete course'));
    }
  } Future<void> filterCourses(String keyword) async {
    try {
      List<Course> filteredCourses = await courseUseCases.filterCourses(keyword);
      emit(CourseLoaded(filteredCourses));
    } catch (e) {
      emit(const CourseError('Failed to filter courses'));
    }
  }
}
