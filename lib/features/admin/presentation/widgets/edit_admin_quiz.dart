import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import '../../../quiz/data/models/quiz_model.dart';
import '../../../quiz/domain/entities/quiz.dart';
import '../cubit/admin_cubit.dart';

void editAdminQuiz(BuildContext context, Quiz quiz) {
  if (quiz is! QuizModel) {
    print("Error: Quiz is not a subtype of QuizModel");
    return;
  }

  QuizModel quizModel = quiz; // Safe casting since we checked the type

  final TextEditingController questionController =
      TextEditingController(text: quizModel.questions.first.question);
  final TextEditingController correctAnswerController = TextEditingController(
      text: quizModel
          .questions.first.options[quizModel.questions.first.correctIndex]);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(
          AppTexts.editQuiz,
          style: Styles.style15grey,
          textAlign: TextAlign.center,
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                    labelText: AppTexts.questions,
                    labelStyle: Styles.style15grey),
              ),
              TextField(
                controller: correctAnswerController,
                decoration: const InputDecoration(
                    labelText: AppTexts.correctAnswer,
                    labelStyle: Styles.style15grey),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            label: const Text(
              AppTexts.cancel,
              style: Styles.style14,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Save button pressed");
              quizModel.questions.first.question = questionController.text;
              quizModel.questions.first
                      .options[quizModel.questions.first.correctIndex] =
                  correctAnswerController.text;
              BlocProvider.of<AdminCubit>(context)
                  .editQuiz(quiz.courseId, quizModel.id, quizModel);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save, color: Colors.green),
            label: const Text(
              AppTexts.save,
              style: Styles.style16,
            ),
          ),
        ],
      );
    },
  );
}
