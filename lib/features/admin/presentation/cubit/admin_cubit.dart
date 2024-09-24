import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quiz/domain/entities/quiz.dart';
import '../../../quiz/domain/repositories/quiz_repo.dart';
import '../../../student/data/models/course_model.dart';
import '../../../student/domain/entities/course_entity.dart';
import '../../../student/domain/usecases/course_use_cases.dart';
import '../../domain/usecases/admin_use_cases.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  List<Course> allCourses = []; // List to store all courses

  final AdminUseCases adminUseCases; // Use cases for admin operations
  final QuizRepository quizRepository; // Repository for quiz operations
  final CourseUseCases courseUseCases; // Use cases for course operations

  AdminCubit(this.adminUseCases, this.quizRepository, this.courseUseCases)
      : super(AdminLoading());

  // Fetch the list of courses
  Future<void> getCourses() async {
    try {
      print("Fetching all courses from Firebase...");
      var querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('isArchived', isEqualTo: false) // Filter non-archived courses
          .get();

      allCourses = querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc.data(), doc.id))
          .toList();

      print("Fetched ${allCourses.length} courses from Firebase.");
      emit(AdminCoursesLoaded(allCourses));
    } catch (e) {
      print("Error while fetching courses: $e");
      emit(AdminError('Failed to fetch courses: $e'));
    }
  }

  // Add a new course and refresh the list
  void addCourse(Course course) async {
    try {
      print("Adding a new course: ${course.title}");
      await adminUseCases.addCourse(course);
      print("Course added successfully.");
      getCourses(); // Fetch updated list after adding the course
    } catch (e) {
      print("Error while adding course: $e");
      emit(AdminError('Error while adding course: $e'));
    }
  }

  // Edit an existing course
  Future<void> editCourse(Course course) async {
    emit(AdminLoading()); // Emit loading state
    try {
      print("Editing course: ${course.title}");
      await adminUseCases.editCourse(course.id, course);
      print("Course edited successfully.");
      getCourses(); // Refresh the list after editing
    } catch (e) {
      print("Error while editing course: $e");
      emit(AdminError(
          "Failed to edit course: $e")); // Emit error if editing fails
    }
  }

  // Delete a course (archive it)
  Future<void> deleteCourse(String courseId) async {
    try {
      print("Attempting to archive course with ID: $courseId");
      Course courseToDelete =
          allCourses.firstWhere((course) => course.id == courseId);
      print("Found course to delete: ${courseToDelete.title}");

      // Mark course as archived
      Course updatedCourse = courseToDelete.copyWith(isArchived: true);
      await adminUseCases.editCourse(updatedCourse.id, updatedCourse);

      // Log the success
      print("Course archived successfully: ${updatedCourse.isArchived}");

      // Fetch the updated list
      getCourses();
    } catch (e) {
      print("Error while archiving course: $e");
      emit(AdminError("Failed to archive course: $e"));
    }
  }

  // Fetch quizzes for a specific course
  Future<void> fetchQuizzes(String courseId) async {
    try {
      print("Fetching quizzes for course ID: $courseId");
      var quizzes = await quizRepository.getQuizzes(courseId);
      print("Fetched ${quizzes.length} quizzes for course ID: $courseId");
      emit(QuizzesLoaded(quizzes)); // Emit the state with loaded quizzes
    } catch (e) {
      print("Error while fetching quizzes: $e");
      emit(AdminError(
          "Failed to fetch quizzes: $e")); // Emit error if fetching fails
    }
  }

  // Add a quiz to a course
  void addQuiz(String courseId, Quiz quiz) async {
    try {
      print("Adding quiz to course ID: $courseId");
      await quizRepository.addQuiz(courseId, quiz);
      print("Quiz added successfully.");
      emit(AdminOperationSuccess(
          'Quiz added successfully')); // Notify of success
      fetchQuizzes(courseId); // Refresh the quiz list
    } catch (e) {
      print("Error while adding quiz: $e");
      emit(AdminError("Failed to add quiz: $e")); // Emit error if adding fails
    }
  }

  // Edit an existing quiz
  Future<void> editQuiz(
      String courseId, String quizId, Quiz updatedQuiz) async {
    try {
      print("Editing quiz ID: $quizId for course ID: $courseId");
      await quizRepository.updateQuiz(courseId, quizId, updatedQuiz);
      print("Quiz edited successfully.");
      emit(AdminOperationSuccess(
          'Quiz updated successfully')); // Notify of success
      fetchQuizzes(courseId); // Refresh the quiz list
    } catch (e) {
      print("Error while editing quiz: $e");
      emit(AdminError(
          "Failed to update quiz: $e")); // Emit error if editing fails
    }
  }

  // Delete a quiz from a course
  Future<void> deleteQuiz(String courseId, String quizId) async {
    try {
      print("Deleting quiz ID: $quizId from course ID: $courseId");
      await quizRepository.deleteQuiz(courseId, quizId);
      print("Quiz deleted successfully.");
      emit(AdminOperationSuccess(
          'Quiz deleted successfully')); // Notify of success
      fetchQuizzes(courseId); // Refresh the quiz list
    } catch (e) {
      print("Error while deleting quiz: $e");
      emit(AdminError(
          "Failed to delete quiz: $e")); // Emit error if deleting fails
    }
  }

  // Fetch archived (deleted) courses
  Future<void> getDeletedCourses() async {
    try {
      print("Fetching archived courses from Firebase...");

      // Query Firebase for courses where 'isArchived' is true
      var querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('isArchived', isEqualTo: true)
          .get();

      var archivedCourses = querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc.data(), doc.id))
          .toList();

      print("Archived courses count: ${archivedCourses.length}");

      emit(AdminCoursesLoaded(archivedCourses)); // Load archived courses
    } catch (e) {
      print("Error while fetching archived courses: $e");
      emit(AdminError('Failed to fetch deleted courses: $e'));
    }
  }

  // Filter courses by a keyword
  void filterCourses(String keyword) {
    if (state is AdminCoursesLoaded) {
      final filteredCourses = (state as AdminCoursesLoaded)
          .courses
          .where((c) => c.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();

      print(
          "Filtered courses count: ${filteredCourses.length} for keyword: $keyword");
      emit(AdminCoursesLoaded(filteredCourses)); // Emit filtered list
    }
  }

  // Sort courses based on filter
  void sortCourses(String filter) {
    List<Course> sortedCourses = allCourses; // Default to the full list

    if (filter == "recency") {
      // Sort by recency
      print("Sorting courses by recency...");
      sortedCourses = allCourses..sort((a, b) => b.date.compareTo(a.date));
    } else if (filter == "alphabetical") {
      // Sort alphabetically
      print("Sorting courses alphabetically...");
      sortedCourses = allCourses..sort((a, b) => a.title.compareTo(b.title));
    }

    print("Sorted courses count: ${sortedCourses.length}");
    emit(AdminCoursesLoaded(sortedCourses)); // Emit sorted list
  }

  // Fetch draft courses
  Future<void> getDraftCourses() async {
    try {
      print("Fetching draft courses...");
      var draftCourses =
          allCourses.where((course) => course.status == "draft").toList();

      print("Fetched ${draftCourses.length} draft courses.");
      emit(AdminCoursesLoaded(draftCourses));
    } catch (e) {
      print("Error while fetching draft courses: $e");
      emit(AdminError('Failed to fetch draft courses: $e'));
    }
  }

  // Restore a course from deleted to all courses
  Future<void> restoreCourse(String courseId) async {
    try {
      print("Restoring course with ID: $courseId");

      // Fetch the course directly from Firestore
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('courses')
          .doc(courseId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw Exception("Course not found");
      }

      Course courseToRestore = CourseModel.fromFirestore(
        doc.data()!,
        doc.id,
      );

      // Set isArchived to false
      Course updatedCourse = courseToRestore.copyWith(isArchived: false);

      await adminUseCases.editCourse(updatedCourse.id, updatedCourse);

      print("Course restored successfully.");
      await getDeletedCourses(); // Refresh the deleted courses list
      // Optionally, refresh the courses list if needed
      // await getCourses();
    } catch (e) {
      print("Error while restoring course: $e");
      emit(AdminError("Failed to restore course: $e"));
    }
  }

  // Permanently delete a course
  Future<void> deleteCoursePermanently(String courseId) async {
    try {
      print("Permanently deleting course with ID: $courseId");
      await adminUseCases.deleteCourse(courseId);
      print("Course deleted permanently.");
      getDeletedCourses(); // Refresh the deleted courses list
    } catch (e) {
      print("Error while deleting course permanently: $e");
      emit(AdminError("Failed to delete course permanently: $e"));
    }
  }
}
