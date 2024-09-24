import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ucourses/core/shared/widgets/style/lottie_loading.dart';
import 'package:ucourses/features/admin/presentation/screens/admin_course_details_screen.dart';
import 'package:ucourses/features/student/domain/entities/course_entity.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants_exports.dart';
import '../cubit/admin_cubit.dart';
import '../functions/course_dialogs.dart';
import '../functions/quiz_actions.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final bool isDeletedTab;

  const CourseCard({
    super.key,
    required this.course,
    required this.isDeletedTab,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth > 800 ? 180 : 120;
    double fontSize = screenWidth > 800 ? 22 : 16;

    return StatefulBuilder(builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: AnimatedScale(
          scale: isHovered ? 1.05 : 1.0, // Scale card on hover
          duration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AdminCourseDetailsScreen(course: widget.course),
              ),
            ),
            child: Card(
              elevation: 15,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: widget.course.id,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: CachedNetworkImage(
                          height: imageHeight,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.course.title,
                        style: Styles.style18.copyWith(fontSize: fontSize),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Text(
                        widget.course.description,
                        style: Styles.style13grey
                            .copyWith(fontSize: fontSize * 0.9),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildActionButtons(context),
                    _buildRatingInfo(context, screenWidth),
                    _buildDateInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    if (widget.isDeletedTab) {
      // In the "Deleted" tab, show "Restore" and "Permanently Delete" buttons
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAnimatedButton(
            context: context,
            icon: Icons.restore,
            color: Colors.green,
            label: "استعادة",
            onPressed: () {
              context.read<AdminCubit>().restoreCourse(widget.course.id);
            },
          ),
          _buildAnimatedButton(
            context: context,
            icon: Icons.delete_forever,
            color: Colors.red,
            label: "حذف نهائي",
            onPressed: () {
              context
                  .read<AdminCubit>()
                  .deleteCoursePermanently(widget.course.id);
            },
          ),
        ],
      );
    } else {
      // In other tabs, show the usual options
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAnimatedButton(
                context: context,
                icon: Icons.edit,
                color: AppColors.secondaryColor.withOpacity(0.8),
                label: AppTexts.editCourse,
                onPressed: () => CourseDialogs.showAddEditCourseDialog(
                  context,
                  course: widget.course,
                ),
              ),
              _buildAnimatedButton(
                context: context,
                icon: Icons.quiz,
                color: AppColors.thirdColor.withOpacity(0.8),
                label: AppTexts.addQuestions,
                onPressed: () =>
                    QuizActions.showAddQuizDialog(context, widget.course.id),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildAnimatedButton(
              context: context,
              icon: Icons.delete,
              color: AppColors.dangerColor.withOpacity(0.8),
              label: "نقل إلى المهملات", // Move to trash in Arabic
              onPressed: () => CourseDialogs.showDeleteConfirmation(
                context,
                widget.course.id,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              isHovered = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isHovered ? Colors.transparent : color,
              border: Border.all(
                color: isHovered ? color : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedScale(
              scale: isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: TextButton.icon(
                icon: Icon(
                  icon,
                  color: isHovered ? color : Colors.white,
                ),
                label: Text(
                  label,
                  style: Styles.style18.copyWith(
                    fontSize: 17,
                    color: isHovered ? color : Colors.white,
                  ),
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingInfo(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: RatingBar.readOnly(
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              halfFilledIcon: Icons.star_half,
              isHalfAllowed: true,
              initialRating: widget.course.rating,
              maxRating: 5,
              filledColor: Colors.amber,
              emptyColor: Colors.grey,
              halfFilledColor: Colors.amber,
              size: screenWidth > 600 ? 32 : 24,
            ),
          ),
          Text(
            ' (${widget.course.rating})',
            style: Styles.style13grey.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            intl.DateFormat('yyyy-MM-dd').format(widget.course.date),
            style: Styles.style13grey.copyWith(fontSize: 14),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.calendar_month, size: 16),
        ],
      ),
    );
  }
}
