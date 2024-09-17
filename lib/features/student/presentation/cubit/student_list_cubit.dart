import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/usecases/student_use_cases.dart';

part 'student_list_state.dart';

class StudentListCubit extends Cubit<StudentListState> {
  final StudentUseCases studentUseCases;
  StudentListCubit(this.studentUseCases) : super(StudentListLoading());

  Future<void> fetchAllStudents() async {
    try {
      print('Cubit: Fetching all students');
      emit(StudentListLoading());
      final students = await studentUseCases.getAllStudents();
      if (students.isEmpty) {
        emit(StudentListEmpty());
      } else {
        emit(StudentListLoaded(students));
      }
    } catch (e) {
      print('Cubit: Error fetching students: $e');
      emit(const StudentListError('Failed to fetch students'));
    }
  }

  Future<void> deleteCompletedCourse(String studentId, String courseId) async {
    try {
      print('Cubit: Deleting course $courseId for student $studentId');
      await studentUseCases.deleteCompletedCourse(studentId, courseId);
      print('Cubit: Successfully deleted course $courseId for student $studentId');
      fetchAllStudents(); // Refresh the student list after deletion
    } catch (e) {
      print('Cubit: Error deleting course: $e');
      emit(const StudentListError('Failed to delete course'));
    }
  }

}
