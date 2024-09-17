import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/data_source/remote/firebase_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';

part 'course_rating_state.dart';

class CourseRatingCubit extends Cubit<CourseRatingState> {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;
  final CourseRepositoryImpl courseRepository;

  CourseRatingCubit(this.firebaseRemoteDataSource, this.courseRepository) : super(CourseRatingInitial());

  Future<void> rateCourse(String courseId, double rating) async {
    emit(CourseRatingLoading());
    try {
      await firebaseRemoteDataSource.updateCourseRating(courseId, rating);
      emit(CourseRatingSuccess());
    } catch (e) {
      emit(CourseRatingFailure(e.toString()));
    }
  } Future<void> updateRating(String courseId, double rating) async {
    emit(CourseRatingLoading());
    try {
      await courseRepository.updateCourseRating(courseId, rating);
      emit(CourseRatingSuccess());
    } catch (e) {
      emit(CourseRatingError('Failed to update rating: $e'));
    }
  }
}
