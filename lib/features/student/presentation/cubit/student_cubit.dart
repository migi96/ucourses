import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/usecases/course_use_cases.dart';
import '../../domain/usecases/student_use_cases.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentUseCases studentUseCases;
  final CourseUseCases courseUseCases;

  StudentCubit(this.studentUseCases, this.courseUseCases) : super(StudentInitial());

  // Updated register method to include username
  Future<void> register(String username, String email, String password) async {
    emit(StudentLoading());
    try {
      final student = await studentUseCases.registerWithEmailPassword(username, email, password);
      if (student != null) {
        emit(StudentRegistered(student));
      } else {
        emit(const StudentError("Registration failed, no student returned"));
      }
    } catch (e) {
      print("Registration Error: $e");
      emit(StudentError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(StudentLoading());
    try {
      final student = await studentUseCases.loginWithEmailPassword(email, password);
      emit(StudentLoggedIn(student!));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  

  Future<void> logout() async {
    try {
      await studentUseCases.logout();
      emit(StudentLoggedOut());
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  } 
}
