import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/student_entity.dart';

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.username,
    required super.email,
    required super.createdAt,
    required super.completedCourses,
  });

  factory StudentModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    List<Map<String, dynamic>> completedCourses = [];
    if (data['completedCourses'] != null) {
      completedCourses = (data['completedCourses'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
    }

    return StudentModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      completedCourses: completedCourses,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedCourses': completedCourses.map((course) => {'courseId': course['courseId'], 'score': course['score']}).toList(),
    };
  }
}
