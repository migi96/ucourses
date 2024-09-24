import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/course_use_cases.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseUseCases courseUseCases;
  List<Course> _allCourses = [];

  CourseCubit(this.courseUseCases) : super(CourseInitial());

  Future<void> getCourses() async {
    emit(CourseLoading());
    try {
      var courses = await courseUseCases.getCourses();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError('Failed to load courses'));
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      await courseUseCases.addCourse(course);
      getCourses();
    } catch (e) {
      emit(CourseError('Failed to add course'));
    }
  }

  Future<void> archiveCourse(String courseId, bool isArchived) async {
    try {
      await courseUseCases.archiveCourse(courseId, isArchived);
      getCourses();
    } catch (e) {
      emit(CourseError('Failed to archive course'));
    }
  }

  Future<void> enrollInCourse(String courseId, String studentId) async {
    try {
      await courseUseCases.enrollInCourse(courseId, studentId);
      emit(CourseEnrolledSuccess());
    } catch (e) {
      emit(CourseError('Failed to enroll in course'));
    }
  }

  Future<void> updateCourseRating(String courseId, double rating) async {
    try {
      await courseUseCases.updateCourseRating(courseId, rating);
      emit(CourseRatingUpdated());
    } catch (e) {
      emit(CourseError('Failed to update rating'));
    }
  }

  void filterCourses(String keyword) {
    if (_allCourses.isEmpty) {
      emit(CourseError('No courses to filter'));
    } else {
      final filteredCourses = _allCourses.where((course) {
        final titleLower = course.title.toLowerCase();
        final descriptionLower = course.description.toLowerCase();
        final searchLower = keyword.toLowerCase();
        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();

      emit(CourseLoaded(filteredCourses));
    }
  }
}
