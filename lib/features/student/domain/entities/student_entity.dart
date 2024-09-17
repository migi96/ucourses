import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String username;
  final String email;
  final DateTime createdAt;
  final List<Map<String, dynamic>> completedCourses;

  Student({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    this.completedCourses = const [],
  });

  factory Student.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Student(
      id: documentId,
      username: data['username'] as String,
      email: data['email'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedCourses: (data['completedCourses'] as List<dynamic>?)
          ?.map((item) => Map<String, dynamic>.from(item as Map))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedCourses': completedCourses.map((course) => {
        'courseId': course['courseId'],
        'score': course['score']
      }).toList(),
    };
  }
}
