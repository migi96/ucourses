import '../../../quiz/domain/entities/quiz.dart';
import '../../../student/domain/entities/course_entity.dart';

// Abstract class for defining different states
abstract class AdminState {}

// State when courses are successfully loaded
class AdminCoursesLoaded extends AdminState {
  final List<Course> courses;
  AdminCoursesLoaded(this.courses);
}

// State when a specific admin operation is successful
class AdminOperationSuccess extends AdminState {
  final String message; // A message indicating success
  AdminOperationSuccess(this.message);
}

// State when an error occurs during admin operations
class AdminError extends AdminState {
  final String message; // A message describing the error
  AdminError(this.message);
}

// State when an operation is loading or in progress
class AdminLoading extends AdminState {}

// State when quizzes are successfully loaded
class QuizzesLoaded extends AdminState {
  final List<Quiz> quizzes;
  QuizzesLoaded(this.quizzes);
}
