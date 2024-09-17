import '../../../quiz/domain/entities/quiz.dart';
import '../../../student/domain/entities/course_entity.dart';

abstract class AdminState {}

class AdminCoursesLoaded extends AdminState {
  final List<Course> courses;
  AdminCoursesLoaded(this.courses);
}

class AdminOperationSuccess extends AdminState {
  final String message;
  AdminOperationSuccess(this.message);
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

class AdminLoading extends AdminState {}

class QuizzesLoaded extends AdminState {
  final List<Quiz> quizzes;
  QuizzesLoaded(this.quizzes);
}
