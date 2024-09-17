import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/features/quiz/data/models/quiz_questions_model.dart';
import 'package:ucourses/features/quiz/presentation/screens/result_screen.dart';
import '../../domain/entities/quiz.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final String courseName; // Now also passing courseName
  final String courseId; // Now also passing courseId

  const QuizScreen(
      {super.key,
      required this.quiz,
      required this.courseName,
      required this.courseId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int> _selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    _selectedIndexes = List.filled(widget.quiz.questions.length, -1);
  }

  void _answerQuestion(int questionIndex, int answerIndex) {
    setState(() {
      _selectedIndexes[questionIndex] = answerIndex;
    });
  }

  void _finishExam() {
    bool allQuestionsAnswered = _selectedIndexes.every((index) => index != -1);
    if (allQuestionsAnswered) {
      double score = 0;
      for (int i = 0; i < widget.quiz.questions.length; i++) {
        if (_selectedIndexes[i] == widget.quiz.questions[i].correctIndex) {
          score++;
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            total: widget.quiz.questions.length,
            questions: widget.quiz.questions
                .map((q) => QuizQuestionModel.fromJson({
                      'question': q.question,
                      'options': q.options,
                      'correctIndex': q.correctIndex,
                    }))
                .toList(),
            selectedIndexes: _selectedIndexes,
            courseId: widget.courseId, // Using dynamically passed courseId
            courseName:
                widget.courseName, // Using dynamically passed courseName
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppTexts.alertTitle,
                style: Styles.style17,
                textAlign: TextAlign.center,
              ),
              Lottie.asset('lib/assets/jsons/animation/error.json',
                  repeat: false, height: 110, width: 110),
            ],
          ),
          content: const Text(AppTexts.alertContent,
              style: Styles.style16, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                AppTexts.ok,
                style: Styles.style14,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GradientContainer(
          firstGradientColor: AppColors.primaryColor,
          secondGradientColor: AppColors.thirdColor,
          myChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTexts.pleaseReadQestionsCarefully,
                  style: Styles.style20White,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.quiz.questions.length,
                    itemBuilder: (context, index) {
                      final question = widget.quiz.questions[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppTexts.question} ${index + 1}: ${question.question!}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...question.options.asMap().entries.map((option) {
                                return ListTile(
                                  title: Text(option.value),
                                  leading: Radio<int>(
                                    value: option.key,
                                    groupValue: _selectedIndexes[index],
                                    onChanged: (int? value) {
                                      _answerQuestion(index, value!);
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _finishExam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        AppTexts.finishExam,
                        style: Styles.style18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
