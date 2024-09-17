import '../../domain/entities/quiz.dart';
import 'quiz_questions_model.dart';

class QuizModel extends Quiz {
  QuizModel( {
    required super.id,
    required super.courseId,
    required List<QuizQuestionModel> super.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,  // Make sure to serialize courseId if it's part of the Quiz model.
      'questions': questions.map((q) => (q as QuizQuestionModel).toJson()).toList(),
    };
  }

  static QuizModel fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      courseId: json['courseId'],  // Ensure courseId is handled if it's part of the JSON.
      questions: (json['questions'] as List)
          .map((q) => QuizQuestionModel.fromJson(q))
          .toList(),
    );
  }

  // Convert a generic Quiz object to a QuizModel. This method assumes that all questions
  // in the Quiz object are actually QuizQuestionModel instances.
  static QuizModel fromQuiz(Quiz quiz) {
    List<QuizQuestionModel> quizQuestionModels = quiz.questions.map((q) =>
      QuizQuestionModel(
        question: q.question,
        options: q.options,
        correctIndex: q.correctIndex,
      )  // Ensure proper type casting.
    ).toList();
    
    return QuizModel(
      id: quiz.id,
      courseId: quiz.courseId,  // Handle courseId which is assumed to be part of the Quiz.
      questions: quizQuestionModels,
    );
  }
}
