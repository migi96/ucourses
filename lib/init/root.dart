import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/quiz/data/datasources/quiz_datasource.dart';
import 'package:ucourses/features/quiz/data/repositories/quiz_repo_impl.dart';
import 'package:ucourses/features/quiz/domain/entities/quiz.dart';
import 'package:ucourses/features/student/presentation/cubit/completed_courses_cubit.dart';
import 'package:ucourses/features/student/presentation/cubit/course_cubit.dart';
import 'package:ucourses/features/student/presentation/cubit/student_cubit.dart';
import 'package:ucourses/features/student/presentation/screens/courses_screen.dart';
import 'package:ucourses/features/student/presentation/screens/student_profile_screen.dart';
import 'package:ucourses/features/student/presentation/screens/student_register_screen.dart';
import 'package:ucourses/main.dart';
import '../features/admin/data/repositories/admin_repository_impl.dart';
import '../features/admin/domain/usecases/admin_use_cases.dart';
import '../features/admin/presentation/cubit/admin_auth_cubit.dart';
import '../features/admin/presentation/cubit/admin_profile_cubit.dart';
import '../features/admin/presentation/screens/admin_courses_screen.dart';
import '../features/admin/presentation/screens/admin_profile_screen.dart';
import '../features/admin/presentation/screens/admin_student_list_screen.dart';
import '../features/data/data_source/remote/firebase_remote_datasource.dart';
import '../features/quiz/presentation/screens/completed_courses_page.dart';
import '../features/quiz/presentation/screens/completed_courses_screen.dart';
import '../features/quiz/presentation/screens/quiz_screen.dart';
import '../features/student/data/repositories/course_repository_impl.dart';
import '../features/student/data/repositories/student_repository_impl.dart';
import '../features/student/domain/entities/course_entity.dart';
import '../features/student/domain/repositories/course_repository.dart';
import '../features/student/domain/usecases/course_use_cases.dart';
import '../features/student/domain/usecases/student_use_cases.dart';
import '../features/student/presentation/cubit/course_rating_cubit.dart';
import '../features/student/presentation/cubit/student_list_cubit.dart';
import '../features/student/presentation/screens/course_details_screen.dart';
import 'home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/main_login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseRemoteDataSource firebaseRemoteDataSource =
        FirebaseRemoteDataSource();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final quizDataSource = QuizDataSource(firestore);
    final quizRepository = QuizRepositoryImpl(quizDataSource);

    // Initialize repositories
    final studentRepository = StudentRepositoryImpl(firebaseRemoteDataSource);
    final courseRepository = CourseRepositoryImpl(firebaseRemoteDataSource);
    final adminRepository = AdminRepositoryImpl();

    // Initialize use cases
    final studentUseCases =
        StudentUseCases(studentRepository, firebaseRemoteDataSource);
    final courseUseCases = CourseUseCases(courseRepository);
    final adminUseCases = AdminUseCases(
      adminRepository,
      courseRepository,
    );

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CourseRepository>(
            create: (context) => CourseRepositoryImpl(firebaseRemoteDataSource),
          ),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<StudentCubit>(
                create: (context) =>
                    StudentCubit(studentUseCases, courseUseCases),
              ),
              BlocProvider<CourseCubit>(
                create: (context) => CourseCubit(courseUseCases),
              ),
              BlocProvider<AdminCubit>(
                create: (context) =>
                    AdminCubit(adminUseCases, quizRepository, courseUseCases),
              ),
              BlocProvider<AdminAuthCubit>(
                create: (context) => AdminAuthCubit(adminUseCases),
              ),
              BlocProvider<AdminProfileCubit>(
                create: (context) => AdminProfileCubit(adminUseCases),
              ),
              BlocProvider<StudentListCubit>(
                create: (context) => StudentListCubit(studentUseCases),
              ),
              BlocProvider<CompletedCoursesCubit>(
                create: (context) => CompletedCoursesCubit(
                  courseRepository:
                      RepositoryProvider.of<CourseRepository>(context),
                  studentId: FirebaseAuth.instance.currentUser?.uid ?? '',
                ),
              ),
              BlocProvider<CourseRatingCubit>(
                create: (context) => CourseRatingCubit(
                    firebaseRemoteDataSource, courseRepository),
              ),
            ],
            child: MaterialApp(
              navigatorObservers: [routeObserver],
              debugShowCheckedModeBanner: false,
              title: 'UCourses',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: '/',
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    return PageTransition(
                      child: const AdminCoursesScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/home':
                    return PageTransition(
                      child: const HomeScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/login':
                    return PageTransition(
                      child: const MainLoginScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/contact_us':
                    return PageTransition(
                      childCurrent: this,
                      child: const ContactUsScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/about_us':
                    return PageTransition(
                      child: const AboutScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300),
                    );

                  case '/courses':
                    return PageTransition(
                      child: const CoursesScreen(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/student_profile':
                    return PageTransition(
                      child: const StudentProfileScreen(),
                      type: PageTransitionType.leftToRight,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/register':
                    return PageTransition(
                      child: const StudentRegisterScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/quiz':
                    final quiz = settings.arguments as Quiz;
                    return PageTransition(
                      child: QuizScreen(
                        quiz: quiz,
                        courseName: '',
                        courseId: quiz.courseId,
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    );
                  case '/courseDetails':
                    final course = settings.arguments as Course;
                    return PageTransition(
                      child: CourseDetailsScreen(course: course),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/admin_courses':
                    return PageTransition(
                      child: const AdminCoursesScreen(),
                      type: PageTransitionType.scale,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 500),
                    );
                  case '/admin_students':
                    return PageTransition(
                      child: const AdminStudentListScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/admin_profile':
                    return PageTransition(
                      child: const AdminProfileScreen(),
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/admin_login':
                    return PageTransition(
                      child: const MainLoginScreen(),
                      type: PageTransitionType.leftToRightWithFade,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/completed_page':
                    String currentStudentId =
                        firebaseAuth.currentUser?.uid ?? '';
                    return PageTransition(
                      child: CompletedCoursesPage(studentId: currentStudentId),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 400),
                    );
                  case '/completed_courses':
                    String currentStudentId =
                        firebaseAuth.currentUser?.uid ?? '';
                    return PageTransition(
                      child:
                          CompletedCoursesScreen(studentId: currentStudentId),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 400),
                    );
                  default:
                    return null;
                }
              },
            )));
  }
}
