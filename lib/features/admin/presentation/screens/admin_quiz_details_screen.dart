import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar.dart';
import '../../../../core/util/auth_utils.dart';
import '../../../quiz/domain/entities/quiz.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/edit_admin_quiz.dart';

class AdminQuizDetailsScreen extends StatelessWidget {
  final Quiz quiz;

  const AdminQuizDetailsScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminOperationSuccess && state.message == "UpdateQuiz") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppTexts.quizUpdatedSuccessfully)),
          );
          BlocProvider.of<AdminCubit>(context)
              .fetchQuizzes(quiz.courseId); // Refresh the data
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: AppTexts.quizDetails),
          endDrawer: AdminDrawer(onLogout: () => logout(context)),
          body: Column(
            children: [
              Expanded(
                child: _buildQuizDetails(context, quiz),
              ),
              OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: const Text(AppTexts.delete, style: Styles.style16),
                    onPressed: () => _showDeleteConfirmation(context, quiz),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.green,
                    ),
                    label: const Text(
                      AppTexts.refresh,
                      style: Styles.style16,
                    ),
                    onPressed: () => BlocProvider.of<AdminCubit>(context)
                        .fetchQuizzes(quiz.courseId),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    label: const Text(AppTexts.editQuiz, style: Styles.style16),
                    onPressed: () => editAdminQuiz(context, quiz),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizDetails(BuildContext context, Quiz quiz) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        padding:
            const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 15),
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) {
          final question = quiz.questions[index];
          return Card(
            elevation: 8,
            child: ExpansionTile(
              leading: const Icon(Icons.question_answer),
              title: Text('Q${index + 1}: ${question.question}'),
              children: List.generate(question.options.length, (optIndex) {
                bool isCorrect = question.correctIndex == optIndex;
                return ListTile(
                  leading: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  title: Text(question.options[optIndex]),
                );
              }),
            ),
          );
        },
      ),
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
}
