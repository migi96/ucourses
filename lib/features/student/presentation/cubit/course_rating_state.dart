part of 'course_rating_cubit.dart';

@immutable
abstract class CourseRatingState {}

class CourseRatingInitial extends CourseRatingState {}

class CourseRatingLoading extends CourseRatingState {}

class CourseRatingSuccess extends CourseRatingState {}

class CourseRatingFailure extends CourseRatingState {
  final String message;
  CourseRatingFailure(this.message);
}
class CourseRatingError extends CourseRatingState {
  final String message;
  CourseRatingError(this.message);
}