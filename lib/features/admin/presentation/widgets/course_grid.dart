import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ucourses/core/shared/widgets/style/lottie_loading.dart';
import 'package:ucourses/features/admin/presentation/screens/admin_course_details_screen.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';

import '../functions/course_actions.dart';
import '../functions/course_dialogs.dart';
import '../functions/quiz_actions.dart';

class CourseGrid extends StatefulWidget {
  final List<Course> courses;

  const CourseGrid({super.key, required this.courses});

  @override
  _CourseGridState createState() => _CourseGridState();
}

class _CourseGridState extends State<CourseGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courses.isEmpty) {
      return const Center(child: Text("No courses available"));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 30),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1 / 0.9,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.courses.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: child,
                ),
              );
            },
            child: _buildCourseCard(context, widget.courses[index]),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminCourseDetailsScreen(course: course),
        ),
      ),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: course.id,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: CachedNetworkImage(
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: course.images,
                  placeholder: (context, url) => const LottieLoading(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                course.title,
                style: Styles.style16Bold,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                course.description,
                style: Styles.style13grey,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => CourseDialogs.showAddEditCourseDialog(
                      context,
                      course: course),
                ),
                IconButton(
                  icon: const Icon(Icons.quiz, color: Colors.green),
                  onPressed: () =>
                      QuizActions.showAddQuizDialog(context, course.id, ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      CourseActions.showDeleteConfirmation(context, course.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
