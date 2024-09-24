import 'package:flutter/material.dart';
import 'package:ucourses/core/shared/widgets/style/error_loading.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';

import '../../../../core/constants/constants_exports.dart';
import 'course_card.dart';

class CourseGrid extends StatefulWidget {
  final List<Course> courses;
  final bool isDeletedTab;

  const CourseGrid({
    super.key,
    required this.courses,
    this.isDeletedTab = false,
  });

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
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 4
            : screenWidth > 600
                ? 2
                : 1;

    if (widget.courses.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ErrorLoading(),
          Text(
            AppTexts.noCoursesAvailable,
            style: Styles.style20White,
          ),
        ],
      ));
    }

    // Inside your CourseGrid's build method

    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true, // Ensures the grid takes only necessary space
        physics:
            const NeverScrollableScrollPhysics(), // Prevents internal grid scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: screenWidth > 600 ? 14 / 16 : 16,
          crossAxisSpacing: 15,
          mainAxisSpacing: 14,
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
            child: CourseCard(
              course: widget.courses[index],
              isDeletedTab: widget.isDeletedTab, // Pass isDeletedTab here
            ),
          );
        },
      ),
    );
  }
}
