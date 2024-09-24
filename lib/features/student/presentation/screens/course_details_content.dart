import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';
import '../../../admin/presentation/widgets/video_player_widget.dart';

class CourseDetailsContent extends StatelessWidget {
  final Course course;

  const CourseDetailsContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.title, color: Colors.deepOrange),
            SizedBox(width: 10),
            Text("Title", style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 10),
        Text(course.title, style: const TextStyle(fontSize: 18)),

        // Displaying course images
        const SizedBox(height: 20),
        if (course.images.isNotEmpty)
          CachedNetworkImage(
            imageUrl: course.images,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),

        // Displaying course intro video
        const SizedBox(height: 20),
        if (course.introVideo != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayerWidget(videoUrl: course.introVideo!),
          ),

        const SizedBox(height: 25),
        const Row(
          children: [
            Icon(Icons.description, color: Colors.deepOrange),
            SizedBox(width: 10),
            Text("Description",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 10),
        Text(course.description, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 25),
        const Row(
          children: [
            Icon(Icons.content_paste, color: Colors.deepOrange),
            SizedBox(width: 10),
            Text("Content", style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        Text(course.content, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
