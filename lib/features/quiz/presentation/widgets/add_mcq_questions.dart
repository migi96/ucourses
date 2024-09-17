import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/constants_exports.dart';

import '../../../admin/presentation/cubit/admin_cubit.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/quiz_questions_model.dart';

class AddMCQsDialog extends StatefulWidget {
  final String courseId;

  const AddMCQsDialog({super.key, required this.courseId});

  @override
  _AddMCQsDialogState createState() => _AddMCQsDialogState();
}

class _AddMCQsDialogState extends State<AddMCQsDialog> {
  int numberOfQuestions = 1;
  List<TextEditingController> questionControllers = [];
  List<List<TextEditingController>> optionsControllers = [];
  List<int> correctAnswerIndexes = [];

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    questionControllers =
        List.generate(numberOfQuestions, (index) => TextEditingController());
    optionsControllers = List.generate(numberOfQuestions,
        (index) => List.generate(4, (index) => TextEditingController()));
    correctAnswerIndexes = List.filled(numberOfQuestions, 0);
  }

  void _saveMCQs() {
    if (widget.courseId.isEmpty) {
      print("Error: Course ID is empty.");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid course ID")));
      return;
    }

    List<QuizQuestionModel> questions = [];
    for (int i = 0; i < numberOfQuestions; i++) {
      String questionText = questionControllers[i].text.trim();
      List<String> options = optionsControllers[i]
          .map((controller) => controller.text.trim())
          .toList();
      int correctIndex = correctAnswerIndexes[i];

      if (questionText.isEmpty || options.any((option) => option.isEmpty)) {
        print("Error: Not all fields are filled correctly.");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("All fields must be filled")));
        return;
      }

      questions.add(QuizQuestionModel(
        question: questionText,
        options: options,
        correctIndex: correctIndex,
      ));
    }

    if (questions.isNotEmpty) {
      QuizModel newQuiz =
          QuizModel(id: '', questions: questions, courseId: widget.courseId);
      BlocProvider.of<AdminCubit>(context).addQuiz(widget.courseId, newQuiz);
      print("Quiz added: ${newQuiz.toJson()}");
      Navigator.of(context).pop();
    } else {
      print("Error: No questions added.");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No questions to add")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(AppTexts.addOrEditMCQ, textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: numberOfQuestions,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      numberOfQuestions = newValue;
                      _updateControllers();
                    });
                  }
                },
                items: List.generate(
                    10,
                    (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text("${index + 1} ${AppTexts.questions}"),
                        )),
              ),
              ...List.generate(
                  numberOfQuestions,
                  (index) => Column(
                        children: [
                          TextField(
                            controller: questionControllers[index],
                            decoration: InputDecoration(
                                labelText: "${AppTexts.question} ${index + 1}"),
                          ),
                          ...List.generate(
                              4,
                              (optIndex) => TextField(
                                    controller: optionsControllers[index]
                                        [optIndex],
                                    decoration: InputDecoration(
                                        labelText:
                                            "${AppTexts.option} ${optIndex + 1}"),
                                  )),
                          DropdownButton<int>(
                            value: correctAnswerIndexes[index],
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  correctAnswerIndexes[index] = newValue;
                                });
                              }
                            },
                            items: List.generate(
                                4,
                                (optIndex) => DropdownMenuItem(
                                      value: optIndex,
                                      child: Text(
                                          "${AppTexts.option} ${optIndex + 1}"),
                                    )),
                          ),
                        ],
                      ))
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: _saveMCQs,
            icon: const Icon(Icons.save),
            label: Text(AppTexts.saveMcqs, style: Styles.style17),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            label: const Text(
              AppTexts.cancel,
              style: Styles.style14,
            ),
          ),
        ],
      ),
    );
  }
}
