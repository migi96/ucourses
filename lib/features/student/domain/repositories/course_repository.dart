import '../entities/course_entity.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> addCourse(Course course);
  Future<void> editCourse(String courseId, Course course);
  Future<void> deleteCourse(String courseId);
  Future<void> archiveCourse(
      String courseId, bool isArchived); // Archive course
  Future<void> enrollInCourse(
      String courseId, String studentId); // Enroll a student
  Future<void> updateCourseRating(String courseId, double newRating);
  Future<Course> getCourseById(String courseId); // Fetch a course by its ID

  // Add this method to fetch completed courses for a student
  Future<List<Course>> getCompletedCourses(String studentId,
      {double? minScore});
}
