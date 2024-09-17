// lib/domain/entities/course.dart

import '../../domain/entities/course_entity.dart';

class CourseModel extends Course {
  @override
  final double score; // Additional property for score

  CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.images,
    required super.rating,
    required this.score,
  });

  factory CourseModel.fromCourse(Course course, {double score = 0.0}) {
    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      content: course.content,
      images: course.images,
      rating: course.rating,
    score: course.score ?? 0.0,  // Use existing score or default to 0.0
    );
  }

  factory CourseModel.fromFirestore(Map<String, dynamic> data, String documentId, {double score = 0.0}) {
    return CourseModel(
      id: documentId,
      title: data['title'] as String? ?? "No Title",
      description: data['description'] as String? ?? "No Description",
      content: data['content'] as String? ?? "No Content",
      images: data['images'] as String? ?? "No Image Available",
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      score: score, // Assume score is provided, if not default to 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'images': images,
      'rating': rating,
      'score': score,
    };
  }
}
