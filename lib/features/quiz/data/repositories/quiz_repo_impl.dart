import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repo.dart';
import '../datasources/quiz_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizDataSource dataSource;

  QuizRepositoryImpl(this.dataSource);

  @override
  Future<void> addQuiz(String courseId, Quiz quiz) async {
    return dataSource.addQuiz(courseId, quiz);
  }

  @override
  Future<void> updateQuiz(String courseId, String quizId, Quiz quiz) async {
    return dataSource.updateQuiz(courseId, quizId, quiz);
  }

  // Update this method to take both courseId and quizId as parameters
  @override
  Future<void> deleteQuiz(String courseId, String quizId) async {
    return dataSource.deleteQuiz(courseId, quizId);
  }

  @override
  Future<List<Quiz>> getQuizzes(String courseId) async {
    return dataSource.getQuizzes(courseId);
  }
}
