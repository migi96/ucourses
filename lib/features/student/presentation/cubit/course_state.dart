import 'package:equatable/equatable.dart';
import '../../domain/entities/course_entity.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  const CourseLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);

  @override
  List<Object> get props => [message];
}

// For when a course is successfully archived or unarchived
class CourseArchived extends CourseState {
  final Course course;
  final bool isArchived;
  const CourseArchived({required this.course, required this.isArchived});

  @override
  List<Object> get props => [course, isArchived];
}

// For when a student successfully enrolls in a course
class CourseEnrolledSuccess extends CourseState {
  @override
  List<Object> get props => [];
}

// For when a course rating is successfully updated
class CourseRatingUpdated extends CourseState {
  @override
  List<Object> get props => [];
}

// State for indicating that the course details are loading (for individual course pages)
class CourseDetailsLoading extends CourseState {}

class CourseDetailsLoaded extends CourseState {
  final Course course;
  const CourseDetailsLoaded(this.course);

  @override
  List<Object> get props => [course];
}

// State for handling course archiving or deletion operations
class CourseOperationSuccess extends CourseState {
  final String message;
  const CourseOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
