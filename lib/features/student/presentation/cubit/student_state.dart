part of 'student_cubit.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoggedIn extends StudentState {
  final Student student;

  const StudentLoggedIn(this.student);
}

class StudentRegistered extends StudentState {
  final Student student;

  const StudentRegistered(this.student);
}

class StudentLoggedOut extends StudentState {}

class StudentError extends StudentState {
  final String message;

  const StudentError(this.message);
}