import '../../../student/domain/entities/course_entity.dart';
import '../../../student/domain/repositories/course_repository.dart';
import '../entities/admin_entity.dart';
import '../repositories/admin_repository.dart';

class AdminUseCases {
  final AdminRepository adminRepository;
  final CourseRepository courseRepository;

  AdminUseCases(this.adminRepository, this.courseRepository);

  // Fetch admin details by adminId
  Future<Admin> getAdminDetails(String adminId) async {
    return await adminRepository.getAdminDetails(adminId);
  }

  // Fetch admin details by email
  Future<Admin> getAdminDetailsByEmail(String email) async {
    return await adminRepository.getAdminDetailsByEmail(email);
  }

  // Update admin details
  Future<void> updateAdminDetails(Admin admin) async {
    return await adminRepository.updateAdminDetails(admin);
  }

  // Other course-related functions (already defined)
  Future<List<Course>> getCourses() async {
    return await courseRepository.getCourses();
  }

  Future<void> addCourse(Course course) async {
    await courseRepository.addCourse(course);
  }

  Future<void> editCourse(String courseId, Course course) async {
    await courseRepository.editCourse(courseId, course);
  }

  Future<void> deleteCourse(String courseId) async {
    await courseRepository.deleteCourse(courseId);
  }

  Future<void> archiveCourse(String courseId, bool isArchived) async {
    await courseRepository.archiveCourse(courseId, isArchived);
  }

  Future<void> enrollInCourse(String courseId, String studentId) async {
    await courseRepository.enrollInCourse(courseId, studentId);
  }

  Future<void> updateCourseRating(String courseId, double newRating) async {
    await courseRepository.updateCourseRating(courseId, newRating);
  }
}
