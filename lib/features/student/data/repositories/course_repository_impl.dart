// lib/data/repositories/course_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/data_source/remote/firebase_remote_datasource.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final FirebaseRemoteDataSource remoteDataSource;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Course>> getCourses() {
    return remoteDataSource.getCourses();
  }

  @override // Assuming CourseModel extends Course or there is a method to convert Course to CourseModel
  Future<Course> addCourse(Course course) async {
    CourseModel courseModel =
        CourseModel.fromCourse(course); // Convert Course to CourseModel
    return remoteDataSource.addCourse(courseModel);
  }



  @override
  Future<void> editCourse(String courseId, Course course) async {
    CourseModel courseModel = CourseModel.fromCourse(course);
    await remoteDataSource.editCourse(courseId, courseModel);
  }

  @override
  Future<void> deleteCourse(String courseId) {
    return remoteDataSource.deleteCourse(courseId);
  }

  @override
  Future<Course> getCourseById(String courseId) async {
    final courseModel = await remoteDataSource.getCourseById(courseId);
    return courseModel;
  }

  Future<void> markCourseAsCompleted(String studentId, String courseId, double score) async {
    try {
      // Call to data source to mark the course as completed
      await remoteDataSource.markCourseAsCompleted(studentId, courseId,score);
    } catch (e) {
      print("Error marking course as completed: $e");
      throw Exception('Failed to update course completion status');
    }
  }

 @override
Future<List<Course>> getCompletedCourses(String studentId, {double? minScore}) async {
  try {
    DocumentSnapshot studentDoc = await firestore.collection('users').doc(studentId).get();
    if (studentDoc.data() == null) {
      throw Exception("No student data found");
    }
    Map<String, dynamic> studentData = studentDoc.data() as Map<String, dynamic>;
    List<dynamic> completedCoursesData = studentData['completedCourses'] ?? [];
    List<Course> completedCourses = [];

    for (var courseData in completedCoursesData) {
      if (courseData is Map<String, dynamic> && courseData.containsKey('courseId')) {
        String courseId = courseData['courseId'];
        DocumentSnapshot courseDoc = await firestore.collection('courses').doc(courseId).get();
        if (!courseDoc.exists) {
          continue; // Skip this course if not found
        }
        Map<String, dynamic> courseDetails = courseDoc.data() as Map<String, dynamic>;
        double courseScore = (courseData['score'] ?? 0.0).toDouble();
        if (minScore == null || courseScore >= minScore) {
          completedCourses.add(CourseModel.fromFirestore(courseDetails, courseDoc.id, score: courseScore));
        }
      }
    }
    return completedCourses;
  } catch (e) {
    print("Error fetching completed courses: $e");
    throw Exception('Failed to fetch completed courses');
  }
}
 @override
  Future<void> updateCourseRating(String courseId, double newRating) async {
    try {
      DocumentReference courseRef = firestore.collection('courses').doc(courseId);
      DocumentSnapshot courseDoc = await courseRef.get();
      if (!courseDoc.exists) {
        throw Exception('Course not found');
      }

      // Retrieve the current rating and rating count
      Map<String, dynamic> courseData = courseDoc.data() as Map<String, dynamic>;
      double currentRating = (courseData['rating'] ?? 0.0).toDouble();
      int ratingCount = (courseData['ratingCount'] ?? 0).toInt();

      // Calculate the new rating
      double updatedRating = ((currentRating * ratingCount) + newRating) / (ratingCount + 1);
      ratingCount += 1;

      // Update the course document with the new rating and rating count
      await courseRef.update({
        'rating': updatedRating,
        'ratingCount': ratingCount,
      });

      print("Rating updated successfully for courseId: $courseId");
    } catch (e) {
      print("Error updating rating: $e");
      throw Exception('Failed to update rating');
    }
  }
}
