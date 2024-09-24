import 'dart:html' as html;
import 'package:flutter/foundation.dart'; // To check for web platform
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
        title: Text(course.title),
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
              if (kIsWeb &&
                  course.introVideo != null &&
                  course.introVideo!.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: HtmlVideoPlayer(videoUrl: course.introVideo!),
                )
              else
                const Text(
                    "No video available or not supported on this platform"),
              const SizedBox(height: 30),
              CourseDetailsContent(course: course),
              const Divider(),
              const SizedBox(height: 10),
              const Text("Quiz Questions",
                  style: TextStyle(color: Colors.grey)),
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

class HtmlVideoPlayer extends StatelessWidget {
  final String videoUrl;

  const HtmlVideoPlayer({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    html.VideoElement videoElement = html.VideoElement()
      ..src = videoUrl
      ..controls = true
      ..autoplay = false;

    return HtmlElementView(
      viewType: 'videoElement-${videoUrl.hashCode}', // Unique ID
    );
  }
}
