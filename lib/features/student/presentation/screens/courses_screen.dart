import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/core/shared/widgets/style/lottie_loading.dart';
import 'package:ucourses/core/shared/widgets/style/student_appbar.dart';
import '../../../../core/shared/widgets/style/custom_appbar.dart';
import '../../../../core/shared/widgets/style/custom_input_field.dart'; // Make sure this path is correct
import '../cubit/course_cubit.dart';
import '../cubit/course_state.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().getCourses();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      context.read<CourseCubit>().getCourses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.courses,
        actions: studentAppBarActions(context),
      ),
      body: GradientContainer(
        firstGradientColor: Colors.white,
        secondGradientColor: Colors.white70,
        myChild: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Divider(
                thickness: 2,
                indent: 150,
                endIndent: 150,
                color: AppColors.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: CustomInputField(
                  labelText: AppTexts.searchCourse,
                  controller: _searchController,
                  suffixIconData: Icons.clear,
                  onClearButtonPressed: _clearSearch,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _clearSearch();
                    } else {
                      context.read<CourseCubit>().filterCourses(value);
                    }
                  },
                  prefixIcon: Icons.search,
                  obscureText: false,
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<CourseCubit, CourseState>(
                listener: (context, state) {
                  if (state is CourseError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CourseLoading) {
                    return  Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                            height: 130, width: 130, child: LottieLoading()),
                        IconButton(
                            onPressed: () {      context.read<CourseCubit>().getCourses();
},
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.deepOrange,
                            ))
                      ],
                    ));
                  } else if (state is CourseLoaded) {
                    if (state.courses.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LottieBuilder.asset(
                            'lib/assets/jsons/animation/error.json',
                            repeat: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            AppTexts.noCoursesAvaliable,
                            style: Styles.style18,
                          ),
                        ],
                      ));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 4 / 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.courses.length,
                        itemBuilder: (context, index) {
                          final course = state.courses[index];
                          return Card(
                            elevation: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: course.images,
                                    placeholder: (context, url) =>
                                        const LottieLoading(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        course.title,
                                        style: Styles.style17,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        course.description,
                                        style: Styles.style15grey,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 70,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/courseDetails',
                                                arguments: course);
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.deepOrange,
                                          ),
                                          child: Text(
                                            AppTexts.more,
                                            style: Styles.style16White,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('State not supported'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
