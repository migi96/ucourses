part of 'student_list_cubit.dart';

abstract class StudentListState extends Equatable {
  const StudentListState();
  
  @override
  List<Object?> get props => [];
}

class StudentListInitial extends StudentListState {}

class StudentListLoading extends StudentListState {}

class StudentListLoaded extends StudentListState {
  final List<Student> students;

  const StudentListLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentListEmpty extends StudentListState {}

class StudentListError extends StudentListState {
  final String error;

  const StudentListError(this.error);

  @override
  List<Object?> get props => [error];
}
