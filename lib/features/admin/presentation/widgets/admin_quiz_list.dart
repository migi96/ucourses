
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import '../../../quiz/domain/entities/quiz.dart';
import '../cubit/admin_cubit.dart';
import '../screens/admin_quiz_details_screen.dart';
import 'edit_admin_quiz.dart';

Widget buildAdminQuizList(BuildContext context, List<Quiz> quizzes) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: quizzes.length,
    itemBuilder: (context, index) {
      final quiz = quizzes[index];
      return Card(
        margin: const EdgeInsets.all(13),
        elevation: 5,
        child: ListTile(
          leading: const Icon(
            Icons.question_mark_outlined,
            color: Colors.deepOrange,
          ),
          title: Text(quiz.id),
          subtitle: Text(
            "${AppTexts.numbOffQuestion}: ${quiz.questions.length}",
            style: Styles.styleBold,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AdminQuizDetailsScreen(quiz: quiz),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => editAdminQuiz(context, quiz),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context, quiz),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showDeleteConfirmation(BuildContext context, Quiz quiz) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(
          AppTexts.confirm,
          textAlign: TextAlign.center,
          style: Styles.style18,
        ),
        content: const Text(
          AppTexts.quizDeletionConfirmation,
          style: Styles.style16,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
            label: const Text(
              AppTexts.cancel,
              style: Styles.style16,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              BlocProvider.of<AdminCubit>(context)
                  .deleteQuiz(quiz.courseId, quiz.id);
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context)
                  .pop(); // Navigate back to the previous screen
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              AppTexts.delete,
              style: Styles.style16,
            ),
          ),
        ],
      );
    },
  );
}
