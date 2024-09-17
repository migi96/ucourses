// Adjust AdminUseCases if necessary to include methods for handling admin entity.

import 'package:firebase_auth/firebase_auth.dart';

import '../../../student/domain/entities/course_entity.dart';
import '../../../student/domain/repositories/course_repository.dart';
import '../entities/admin_entity.dart';
import '../repositories/admin_repository.dart';

class AdminUseCases {
  final AdminRepository adminRepository;
  final CourseRepository courseRepository;
  final FirebaseAuth _firebaseAuth;

  AdminUseCases(this.adminRepository, this.courseRepository, this._firebaseAuth);

  Future<Admin> getAdminDetails(String adminId) {
    return adminRepository.getAdminDetails(adminId);
  }

  Future<void> updateAdminDetails(Admin admin) {
    return adminRepository.updateAdminDetails(admin);
  }
  Future<List<Course>> getCourses() {
    return courseRepository.getCourses();
  }

  Future<void> addCourse(Course course) {
    return courseRepository.addCourse(course);
    
  }

  Future<void> editCourse(String courseId, Course course) {
    return courseRepository.editCourse(courseId, course);
  }

  Future<void> deleteCourse(String courseId) {
    return courseRepository.deleteCourse(courseId);
  }
// Inside AdminUseCases
Future<bool> authenticateAdmin(String email, String password) async {
  return adminRepository.authenticateAdmin(email, password);
}
Future<Admin> getAdminDetailsByEmail(String email) async {
  return adminRepository.getAdminDetailsByEmail(email);
}
  Future<void> logoutAdmin() async {
    try {
      await _firebaseAuth.signOut();  // Sign out from Firebase Auth
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }
}
