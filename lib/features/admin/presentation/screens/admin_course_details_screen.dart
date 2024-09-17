
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar.dart';
import 'package:ucourses/core/shared/widgets/style/lottie_loading.dart';
import '../../../student/domain/entities/course_entity.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';
import '../functions/course_actions.dart';
import '../functions/course_dialogs.dart';
import '../widgets/admin_course_details_content.dart';
import '../widgets/admin_quiz_list.dart';

class AdminCourseDetailsScreen extends StatelessWidget {
  final Course course;

  const AdminCourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AdminCubit>(context).fetchQuizzes(course.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: course.title,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                CourseDialogs.showAddEditCourseDialog(context, course: course),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                CourseActions.showDeleteConfirmation(context, course.id),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Card(
                  elevation: 9,
                  child: CachedNetworkImage(
                    imageUrl: course.images,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LottieLoading(),
                    errorWidget: (context, url, error) => Image.asset(
                      'lib/assets/images/icons/placeholder.png',
                      height: 200,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CourseDetailsContent(course: course),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                AppTexts.quizQestions,
                style: Styles.style15grey,
              ),
              BlocBuilder<AdminCubit, AdminState>(
                builder: (context, state) {
                  if (state is QuizzesLoaded) {
                    return buildAdminQuizList(context, state.quizzes);
                  } else if (state is AdminLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
