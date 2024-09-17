import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/app_colors.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import '../../../../core/shared/widgets/style/lottie_loading.dart';
import '../../../../core/util/pdf_util.dart';
import '../../../student/presentation/cubit/completed_courses_cubit.dart';
import '../../../student/presentation/cubit/completed_courses_state.dart';
import '../../../student/presentation/cubit/student_cubit.dart';

class CompletedCoursesScreen extends StatelessWidget {
  final String studentId;

  const CompletedCoursesScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    context
        .read<CompletedCoursesCubit>()
        .getCompletedCourses(); // Trigger fetching

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<CompletedCoursesCubit, CompletedCoursesState>(
          builder: (context, state) {
            if (state is CompletedCoursesLoading) {
              return const Center(
                  child: SizedBox(
                      height: 130, width: 130, child: LottieLoading()));
            } else if (state is CompletedCoursesLoaded) {
              if (state.completedCourses.isEmpty) {
                return GradientContainer(
                  firstGradientColor: AppColors.primaryColor,
                  secondGradientColor: AppColors.secondaryColor,
                  myChild: Center(
                      child: Card(
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(120),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LottieBuilder.asset(
                              'lib/assets/jsons/animation/error.json'),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            AppTexts.noCompletedCoursesFound,
                            style: Styles.style18,
                          ),
                        ],
                      ),
                    ),
                  )),
                );
              }
              return GradientContainer(
                firstGradientColor: AppColors.primaryColor,
                secondGradientColor: AppColors.secondaryColor,
                myChild: ListView.builder(
                  itemCount: state.completedCourses.length,
                  itemBuilder: (context, index) {
                    final course = state.completedCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Card(
                        elevation: 9,
                        child: ListTile(
                          title: Text(
                            course.title,
                            style: Styles.style18,
                          ),
                          subtitle: Text(
                            course.description,
                            style: Styles.style15grey,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download_rounded,
                                color: Colors.green),
                            onPressed: () async {
                              if (context.read<StudentCubit>().state
                                  is StudentLoggedIn) {
                                String studentName = (context
                                        .read<StudentCubit>()
                                        .state as StudentLoggedIn)
                                    .student
                                    .username;
                                double score = state.completedCourses[index]
                                    .score; // Ensure score is correctly used from the course
                                print(
                                    "Downloading PDF for ${state.completedCourses[index].title} with score: $score"); // Debug print to check the score being used

                                await PdfUtility.generateAndDownloadPDF(
                                    studentName,
                                    state.completedCourses[index].title,
                                    score);
                              } else {
                                print(
                                    "Download PDF failed: User not logged in");
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is CompletedCoursesError) {
              return Center(
                  child: Text(
                state.message,
                style: Styles.style17,
              ));
            }
            return const Center(child: Text(AppTexts.error));
          },
        ),
      ),
    );
  }
}
