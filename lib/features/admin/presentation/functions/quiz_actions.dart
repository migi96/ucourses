// quiz_actions.dart
import 'package:flutter/material.dart';

import '../../../quiz/presentation/widgets/add_mcq_questions.dart';

class QuizActions {
  static void showAddQuizDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AddMCQsDialog(courseId: courseId),
    );
  }
}
