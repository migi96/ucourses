import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import '../../data/models/quiz_questions_model.dart';
import 'certificate_screen.dart';

class ResultScreen extends StatelessWidget {
  final double score;
  final int total;
  final List<QuizQuestionModel> questions;
  final List<int> selectedIndexes;
  final String courseName;
  final String courseId;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.questions,
    required this.selectedIndexes,
    required this.courseName,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${AppTexts.yourScore}: $score/$total',
                  style: Styles.style25,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final selectedAnswerIndex = selectedIndexes[index];
                      final correctAnswerIndex = question.correctIndex;

                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.question!,
                                style: Styles.style18,
                              ),
                              const SizedBox(height: 5),
                              ...question.options.asMap().entries.map(
                                    (entry) => ListTile(
                                      title: Text(
                                        entry.value,
                                        style: TextStyle(
                                          color: entry.key == correctAnswerIndex
                                              ? Colors.green
                                              : entry.key == selectedAnswerIndex
                                                  ? Colors.red
                                                  : Colors.black,
                                          fontWeight:
                                              entry.key == selectedAnswerIndex
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                      leading: Radio<int>(
                                        value: entry.key,
                                        groupValue: selectedAnswerIndex,
                                        onChanged: null,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CertificateScreen(
                            score: score,
                            courseName: courseName,
                            courseId: courseId,
                            totalScore: total,
                          )
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text(
                      AppTexts.viewCertificate,
                      style: Styles.style16White,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
