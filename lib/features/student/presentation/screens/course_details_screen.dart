import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ucourses/core/constants/app_colors.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_state.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';
import 'package:ucourses/features/student/presentation/cubit/course_rating_cubit.dart';
import '../../../../core/shared/widgets/style/lottie_loading.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> buildContentPages(List<String> contentLines, int linesPerPage) {
    List<Widget> pages = [];
    int numPages = (contentLines.length / linesPerPage).ceil();
    for (int i = 0; i < numPages; i++) {
      int startLine = i * linesPerPage;
      int endLine = startLine + linesPerPage;
      if (endLine > contentLines.length) endLine = contentLines.length;
      String pageContent = contentLines.sublist(startLine, endLine).join('\n');
      pages.add(SingleChildScrollView(
        child: Text(
          pageContent,
          style: Styles.style16,
        ),
      ));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> contentLines = widget.course.content.split('\n');
    const int linesPerPage = 10;
    final int numPages = (contentLines.length / linesPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(widget.course.title),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 10,
                child: CachedNetworkImage(
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: widget.course.images,
                  placeholder: (context, url) => const LottieLoading(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                AppTexts.courseTitle,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              Text(
                widget.course.title,
                style: Styles.style16,
              ),
              const SizedBox(height: 20),
              const Text(
                AppTexts.courseDescripition,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              Text(
                widget.course.description,
                style: Styles.style16,
              ),
              const SizedBox(height: 20),
              const Text(
                AppTexts.courseContent,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200, // Adjust the height as needed
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: buildContentPages(contentLines, linesPerPage),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(numPages, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPage == index
                                  ? AppColors.primaryColor
                                  : AppColors.fourthColor,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: Styles.style16White,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                AppTexts.courseRating,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              BlocBuilder<CourseRatingCubit, CourseRatingState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      RatingBar.builder(
                        initialRating: widget.course.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          context
                              .read<CourseRatingCubit>()
                              .updateRating(widget.course.id, rating);
                        },
                      ),
                      if (state is CourseRatingLoading)
                        const CircularProgressIndicator(),
                      if (state is CourseRatingError)
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AdminCubit>().fetchQuizzes(widget.course.id);
                  },
                  icon: const Icon(
                    Icons.quiz,
                    color: Colors.white,
                  ),
                  label: Text(
                    AppTexts.takeQuiz,
                    style: Styles.style16White,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.thirdColor,
                  ),
                ),
              ),
              BlocListener<AdminCubit, AdminState>(
                listener: (context, state) {
                  if (state is QuizzesLoaded) {
                    if (state.quizzes.isNotEmpty) {
                      final quiz = state.quizzes.first;
                      Navigator.pushNamed(context, '/quiz', arguments: quiz);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("No quizzes available for this course")),
                      );
                    }
                  } else if (state is AdminError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
