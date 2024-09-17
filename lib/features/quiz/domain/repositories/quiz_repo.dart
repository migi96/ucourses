import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<void> addQuiz(String courseId, Quiz quiz);
  Future<void> updateQuiz(String courseId, String quizId, Quiz quiz);
  Future<void> deleteQuiz(String courseId, String quizId);
  Future<List<Quiz>> getQuizzes(String courseId);
}
