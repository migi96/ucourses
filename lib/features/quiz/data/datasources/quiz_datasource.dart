import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/quiz.dart';
import '../models/quiz_model.dart';

class QuizDataSource {
  final FirebaseFirestore firestore;

  QuizDataSource(this.firestore);

 Future<void> addQuiz(String courseId, Quiz quiz) async {
  DocumentReference docRef = await firestore.collection('courses').doc(courseId).collection('quizzes').add((quiz as QuizModel).toJson());
  // You can optionally update the quiz ID here if needed
  await docRef.update({'id': docRef.id});
}


  Future<void> updateQuiz(String courseId, String quizId, Quiz quiz) async {
    await firestore.collection('courses').doc(courseId).collection('quizzes').doc(quizId).update((quiz as QuizModel).toJson());
  }

 Future<void> deleteQuiz(String courseId, String quizId) async {
  await firestore.collection('courses').doc(courseId).collection('quizzes').doc(quizId).delete();
}

  Future<List<Quiz>> getQuizzes(String courseId) async {
    QuerySnapshot snapshot = await firestore.collection('courses').doc(courseId).collection('quizzes').get();
    return snapshot.docs.map((doc) => QuizModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
}
