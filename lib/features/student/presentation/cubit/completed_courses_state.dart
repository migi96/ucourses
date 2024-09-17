
import 'package:equatable/equatable.dart';
import 'package:ucourses/features/student/data/models/course_model.dart';




abstract class CompletedCoursesState extends Equatable {
  const CompletedCoursesState();

  @override
  List<Object> get props => [];
}

class CompletedCoursesInitial extends CompletedCoursesState {}

class CompletedCoursesLoading extends CompletedCoursesState {}

class CompletedCoursesLoaded extends CompletedCoursesState {
  final List<CourseModel> completedCourses;
  const CompletedCoursesLoaded(this.completedCourses);

  @override
  List<Object> get props => [completedCourses];
}

class CompletedCoursesError extends CompletedCoursesState {
  final String message;
  const CompletedCoursesError(this.message);

  @override
  List<Object> get props => [message];
}
