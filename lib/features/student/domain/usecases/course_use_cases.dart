import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CourseUseCases {
  final CourseRepository courseRepository;

  CourseUseCases(this.courseRepository);

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

  Future<Course> getCourseById(String courseId) async {
    return await courseRepository.getCourseById(courseId);
  }

  Future<List<Course>> filterCourses(String keyword) async {
    List<Course> courses = await getCourses();
    return courses
        .where((c) => c.title.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  // Archive or unarchive a course
  Future<void> archiveCourse(String courseId, bool isArchived) async {
    await courseRepository.archiveCourse(courseId, isArchived);
  }

  // Enroll a student in a course
  Future<void> enrollInCourse(String studentId, String courseId) async {
    await courseRepository.enrollInCourse(studentId, courseId);
  }

  // Update the rating of a course
  Future<void> updateCourseRating(String courseId, double newRating) async {
    await courseRepository.updateCourseRating(courseId, newRating);
  }
}
