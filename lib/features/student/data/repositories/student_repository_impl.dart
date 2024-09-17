// lib/data/repositories/student_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ucourses/features/student/data/models/student_model.dart';

import '../../../data/data_source/remote/firebase_remote_datasource.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final FirebaseRemoteDataSource remoteDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<StudentModel> registerWithEmailPassword(String username, String email, String password) async {
    try {
      print('Repository: Registering user with email: $email');
      return await remoteDataSource.registerWithEmailPassword(username, email, password);
    } catch (e) {
      print("Repository Registration Error: $e");
      rethrow;
    }
  }

  @override
  Future<StudentModel> loginWithEmailPassword(String email, String password) async {
    try {
      print('Repository: Logging in user with email: $email');
      return await remoteDataSource.loginWithEmailPassword(email, password);
    } catch (e) {
      print('Repository Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<StudentModel>> getAllStudents() async {
    try {
      print('Repository: Fetching all students');
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => StudentModel.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching student data: $e');
      throw Exception('Failed to fetch students');
    }
  }

 @override
  Future<void> deleteCompletedCourse(String studentId, String courseId) async {
    try {
      print('Repository: Deleting course $courseId for student $studentId');
      final userDoc = _firestore.collection('users').doc(studentId);
      
      // Fetch the current document to verify its structure
      DocumentSnapshot docSnapshot = await userDoc.get();
      print('Current user document before deletion: ${docSnapshot.data()}');

      if (docSnapshot.exists) {
        List<dynamic> completedCourses = (docSnapshot.data() as Map<String, dynamic>)['completedCourses'] ?? [];
        completedCourses = completedCourses.where((course) => course['courseId'] != courseId).toList();

        await userDoc.update({
          'completedCourses': completedCourses,
        });

        // Fetch the document again to check if the update worked
        docSnapshot = await userDoc.get();
        print('User document after deletion: ${docSnapshot.data()}');
      } else {
        print('User document does not exist.');
      }

      print('Repository: Successfully deleted course $courseId for student $studentId');
    } catch (e) {
      print('Error deleting completed course: $e');
      throw Exception('Failed to delete completed course');
    }
  }

  @override
  Future<void> logout() async {
    try {
      print('Repository: Logging out user');
      await remoteDataSource.logout();
    } catch (e) {
      print('Repository Logout Error: $e');
      rethrow;
    }
  }
}
