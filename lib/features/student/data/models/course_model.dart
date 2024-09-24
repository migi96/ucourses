import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/course_entity.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.images,
    required super.rating,
    required super.isArchived,
    required super.status,
    required super.score,
    super.introVideo,
    required super.date, // Make 'date' a named argument and required
  });

  // Factory method to create CourseModel from Course
  factory CourseModel.fromCourse(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      content: course.content,
      images: course.images,
      rating: course.rating,
      isArchived: course.isArchived,
      score: course.score ?? 0.0,
      introVideo: course.introVideo,
      status: course.status,
      date: course.date, // Pass 'date' as a named argument
    );
  }

  factory CourseModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return CourseModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      images: data['images'] ?? '',
      rating: (data['rating'] as num).toDouble(),
      isArchived: data['isArchived'] ?? false, // Make sure this field is here
      status: data['status'] ?? 'draft',
      score: (data['score'] as num?)?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Factory method to create CourseModel from Firestore data
  // factory CourseModel.fromFirestore(
  //     Map<String, dynamic> data, String documentId) {
  //   return CourseModel(
  //     id: documentId,
  //     title: data['title'] ?? "No Title",
  //     description: data['description'] ?? "No Description",
  //     content: data['content'] ?? "No Content",
  //     images: data['images'] ?? "No Image Available",
  //     rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
  //     isArchived: data['isArchived'] ?? false,
  //     introVideo: data['introVideo'],
  //     status: data['status'] ?? "No Status",
  //     score: (data['score'] as num?)?.toDouble() ?? 0.0,
  //     date: (data['date'] as Timestamp)
  //         .toDate(), // Convert Firestore Timestamp to DateTime
  //   );
  // }

  // Method to convert CourseModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'images': images,
      'rating': rating,
      'isArchived': isArchived,
      'introVideo': introVideo,
      'status': status,
      'score': score,
      'date': date, // Ensure date is stored in Firestore format
    };
  }
}
