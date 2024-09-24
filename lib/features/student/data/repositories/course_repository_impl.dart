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

  @override
  Future<Course> addCourse(Course course) async {
    CourseModel courseModel = CourseModel.fromCourse(course);
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

  // Implement the new getCompletedCourses method
  @override
  Future<List<Course>> getCompletedCourses(String studentId,
      {double? minScore}) async {
    try {
      DocumentSnapshot studentDoc =
          await firestore.collection('users').doc(studentId).get();
      if (studentDoc.data() == null) {
        throw Exception("No student data found");
      }
      Map<String, dynamic> studentData =
          studentDoc.data() as Map<String, dynamic>;
      List<dynamic> completedCoursesData =
          studentData['completedCourses'] ?? [];
      List<Course> completedCourses = [];

      for (var courseData in completedCoursesData) {
        if (courseData is Map<String, dynamic> &&
            courseData.containsKey('courseId')) {
          String courseId = courseData['courseId'];
          DocumentSnapshot courseDoc =
              await firestore.collection('courses').doc(courseId).get();
          if (!courseDoc.exists) {
            continue; // Skip this course if not found
          }
          Map<String, dynamic> courseDetails =
              courseDoc.data() as Map<String, dynamic>;
          double courseScore = (courseData['score'] ?? 0.0).toDouble();
          if (minScore == null || courseScore >= minScore) {
            completedCourses.add(CourseModel.fromFirestore(
              courseDetails,
              courseDoc.id,
            ));
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
  Future<void> archiveCourse(String courseId, bool isArchived) async {
    try {
      DocumentReference courseRef =
          firestore.collection('courses').doc(courseId);

      // Check if the course exists before updating
      DocumentSnapshot courseDoc = await courseRef.get();
      if (!courseDoc.exists) {
        throw Exception('Course not found');
      }

      // Update the isArchived field in the Firestore document
      await courseRef.update({'isArchived': isArchived});
      print('Course archived status updated to: $isArchived');
    } catch (e) {
      print("Error archiving course: $e");
      throw Exception('Failed to update course archive status');
    }
  }

  @override
  Future<void> enrollInCourse(String courseId, String studentId) async {
    try {
      DocumentReference studentRef =
          firestore.collection('users').doc(studentId);

      // Check if the student exists before updating
      DocumentSnapshot studentDoc = await studentRef.get();
      if (!studentDoc.exists) {
        throw Exception('Student not found');
      }

      // Add the course to the student's enrolledCourses array
      await studentRef.update({
        'enrolledCourses': FieldValue.arrayUnion([courseId])
      });
      print('Student $studentId enrolled in course $courseId');
    } catch (e) {
      print("Error enrolling student in course: $e");
      throw Exception('Failed to enroll student in course');
    }
  }

  @override
  Future<void> updateCourseRating(String courseId, double newRating) async {
    try {
      DocumentReference courseRef =
          firestore.collection('courses').doc(courseId);

      // Check if the course exists before updating
      DocumentSnapshot courseDoc = await courseRef.get();
      if (!courseDoc.exists) {
        throw Exception('Course not found');
      }

      Map<String, dynamic> courseData =
          courseDoc.data() as Map<String, dynamic>;

      // Retrieve the current rating and rating count
      double currentRating = (courseData['rating'] ?? 0.0).toDouble();
      int ratingCount = (courseData['ratingCount'] ?? 0).toInt();

      // Calculate the new rating
      double updatedRating =
          ((currentRating * ratingCount) + newRating) / (ratingCount + 1);
      ratingCount += 1;

      // Update the course document with the new rating and rating count
      await courseRef.update({
        'rating': updatedRating,
        'ratingCount': ratingCount,
      });

      print('Course rating updated to: $updatedRating');
    } catch (e) {
      print("Error updating course rating: $e");
      throw Exception('Failed to update course rating');
    }
  }
}
