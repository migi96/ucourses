// lib/domain/entities/quiz.dart

class Quiz {
  final String id;
  final List<QuizQuestion> questions;
    final String courseId; // Ensure this property exists

  Quiz( {required this.id, required this.questions,required this.courseId,});
}

class QuizQuestion {
  late String? question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
