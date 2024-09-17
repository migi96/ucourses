// lib/data/data_source/remote/firebase_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../student/data/models/course_model.dart';
import '../../../student/data/models/student_model.dart';

class FirebaseRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StudentModel> registerWithEmailPassword(String username, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      var user = StudentModel(
        id: userCredential.user!.uid,
        username: username,
        email: email,
        createdAt: DateTime.now(),
        completedCourses: [],
      );
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("DataSource Registration Error: $e");
      }
      rethrow;
    }
  }

  Future<StudentModel> loginWithEmailPassword(String email, String password) async {
    var userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    var doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
    return StudentModel.fromDocumentSnapshot(doc);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<List<CourseModel>> getCourses() async {
    var querySnapshot = await _firestore.collection('courses').get();
    return querySnapshot.docs.map((doc) {
      return CourseModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  Future<CourseModel> addCourse(CourseModel course) async {
    try {
      DocumentReference docRef = await _firestore.collection('courses').add(course.toJson());
      return CourseModel(
        id: docRef.id,
        title: course.title,
        description: course.description,
        content: course.content,
        images: course.images,
        rating: course.rating,
        score: 0.0, // Default score for a new course
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error adding course to Firestore: $e');
      }
      throw Exception('Failed to add course: $e');
    }
  }

  Future<void> editCourse(String courseId, CourseModel course) async {
    await _firestore.collection('courses').doc(courseId).update(course.toJson());
  }

  Future<void> deleteCourse(String courseId) async {
    if (kDebugMode) {
      print("Attempting to delete course with ID: $courseId");
    }
    if (courseId.isEmpty) {
      throw ArgumentError("Course ID cannot be empty for deletion.");
    }
    await _firestore.collection('courses').doc(courseId).delete();
  }

  Future<List<StudentModel>> fetchAllStudents() async {
    try {
      var querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => StudentModel.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      throw Exception('Failed to fetch users');
    }
  }

  Future<CourseModel> getCourseById(String courseId) async {
    final docSnapshot = await _firestore.collection('courses').doc(courseId).get();
    return CourseModel.fromFirestore(docSnapshot.data() as Map<String, dynamic>, courseId);
  }

  Future<List<CourseModel>> getCompletedCourses(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      assert(userDoc.exists && userDoc.data() != null, "User document does not exist or is null");

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
      assert(userData['completedCourses'] is List, "completedCourses is not a List");

      List<dynamic> completedCoursesData = List.from(userData['completedCourses']);
      List<CourseModel> completedCourses = [];

      for (var courseData in completedCoursesData) {
        assert(courseData is Map<String, dynamic>, "courseData must be a Map");
        assert(courseData.containsKey('courseId') && courseData.containsKey('score'), "courseData missing 'courseId' or 'score'");

        String courseId = courseData['courseId'];
        double score;

        try {
          score = (courseData['score'] as num).toDouble();
        } catch (e) {
          print("Failed to convert score to double for courseId $courseId: ${courseData['score']}");
          continue;
        }

        DocumentSnapshot courseDoc = await _firestore.collection('courses').doc(courseId).get();
        assert(courseDoc.exists && courseDoc.data() != null, "Course document not found or empty for ID: $courseId");

        Map<String, dynamic> courseDetails = courseDoc.data() as Map<String, dynamic>;
        completedCourses.add(CourseModel.fromFirestore(courseDetails, courseDoc.id, score: score));
      }

      return completedCourses;
    } catch (e) {
      print("Error fetching completed courses: $e");
      throw Exception('Failed to fetch completed courses: $e');
    }
  }

  Future<void> markCourseAsCompleted(String userId, String courseId, double score) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      Map<String, dynamic> completedCourse = {'courseId': courseId, 'score': score};
      await userRef.update({'completedCourses': FieldValue.arrayUnion([completedCourse])});
      print("Course marked as completed with score successfully.");
    } catch (e) {
      print("Error marking course as completed: $e");
      throw Exception('Failed to mark course as completed: $e');
    }
  }

  Future<void> updateCourseRating(String courseId, double rating) async {
    DocumentReference courseRef = _firestore.collection('courses').doc(courseId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot courseSnapshot = await transaction.get(courseRef);
      var courseData = courseSnapshot.data();

      if (courseData == null || courseData is! Map<String, dynamic> || !courseSnapshot.exists) {
        throw Exception("Course not found or data is invalid");
      }

      double newRating = rating;
      int ratingCount = 1;

      if (courseData.containsKey('rating') && courseData.containsKey('ratingCount')) {
        double currentRating = (courseData['rating'] as num?)?.toDouble() ?? 0.0;
        ratingCount = (courseData['ratingCount'] as num?)?.toInt() ?? 0;
        newRating = ((currentRating * ratingCount) + rating) / (ratingCount + 1);
        ratingCount += 1;
      }

      transaction.update(courseRef, {'rating': newRating, 'ratingCount': ratingCount});
    });
  }
}
