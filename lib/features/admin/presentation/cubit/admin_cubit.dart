import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quiz/domain/entities/quiz.dart';
import '../../../quiz/domain/repositories/quiz_repo.dart';
import '../../../student/domain/entities/course_entity.dart';
import '../../../student/domain/usecases/course_use_cases.dart';
import '../../domain/usecases/admin_use_cases.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminUseCases adminUseCases;
  final QuizRepository quizRepository;
  final CourseUseCases courseUseCases;

  AdminCubit(this.adminUseCases, this.quizRepository, this.courseUseCases)
      : super(AdminLoading());

  Future<void> getCourses() async {
    try {
      var courses = await adminUseCases.getCourses();
      emit(AdminCoursesLoaded(courses));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  void addCourse(Course course) async {
    try {
      await adminUseCases.addCourse(course);
      getCourses();
    } catch (e) {
      emit(AdminError('Error while adding course: $e'));
    }
  }

  void addQuiz(String courseId, Quiz quiz) async {
    try {
      await quizRepository.addQuiz(courseId, quiz);
      emit(AdminOperationSuccess('Quiz added successfully'));
      fetchQuizzes(courseId); // Refresh quiz list after adding
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> editQuiz(
      String courseId, String quizId, Quiz updatedQuiz) async {
    try {
      await quizRepository.updateQuiz(courseId, quizId, updatedQuiz);
      emit(AdminOperationSuccess('Quiz updated successfully'));
      fetchQuizzes(courseId); // Refresh quiz list after updating
    } catch (e) {
      emit(AdminError("Failed to update quiz: $e"));
    }
  }

  Future<void> deleteQuiz(String courseId, String quizId) async {
    try {
      await quizRepository.deleteQuiz(courseId, quizId);
      emit(AdminOperationSuccess('Quiz deleted successfully'));
      fetchQuizzes(courseId); // Refresh quiz list after deletion
    } catch (e) {
      emit(AdminError("Failed to delete quiz: $e"));
    }
  }

  Future<void> fetchQuizzes(String courseId) async {
    try {
      var quizzes = await quizRepository.getQuizzes(courseId);
      emit(QuizzesLoaded(quizzes));
    } catch (e) {
      emit(AdminError("Failed to fetch quizzes: $e"));
    }
  }

  Future<void> editCourse(Course course) async {
    emit(AdminLoading());
    try {
      await adminUseCases.editCourse(course.id, course);
      getCourses(); // Refresh the list
    } catch (e) {
      emit(AdminError("Failed to edit course: $e"));
    }
  }

  Future<void> deleteCourse(String courseId) async {
    if (courseId.isEmpty) {
      print("Invalid course ID: $courseId");
      return; // Exit if courseId is invalid to prevent errors
    }

    try {
      await adminUseCases.deleteCourse(courseId);
      getCourses(); // Refresh the list after deletion
    } catch (e) {
      emit(AdminError("Failed to delete course: $e"));
    }
  }

  void filterCourses(String keyword) {
    if (state is AdminCoursesLoaded) {
      final filteredCourses = (state as AdminCoursesLoaded)
          .courses
          .where((c) => c.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      emit(AdminCoursesLoaded(filteredCourses));
    }
  }

}
