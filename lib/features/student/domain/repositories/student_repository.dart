// lib/domain/repositories/user_repository.dart

import 'package:ucourses/features/student/domain/entities/student_entity.dart';

abstract class StudentRepository {
  // Updated to include the username parameter for registration
  Future<Student> registerWithEmailPassword(String email, String password, String username);

  Future<Student> loginWithEmailPassword(String email, String password);


  // Method to fetch all students remains unchanged
  Future<List<Student>> getAllStudents();
  // Method to delete completed course
  Future<void> deleteCompletedCourse(String studentId, String courseId);

  // Method to log out remains unchanged
  Future<void> logout();
}
