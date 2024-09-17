import '../../domain/entities/quiz.dart';

class QuizQuestionModel extends QuizQuestion {
  QuizQuestionModel({
    required super.question,
    required super.options,
    required super.correctIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
    };
  }

  static QuizQuestionModel fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
    );
  }
}
