import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/init/screens/main_header_screen.dart';
import '../core/shared/widgets/decorators/index.dart';
import 'screens/carousel_screen.dart';
import 'screens/services_section_screen.dart';
import 'widgets/carousel_item.dart';
import 'screens/footer_screen.dart';
import 'screens/testimonial_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Widget> _widgets = [
    const MainHeaderScreen(),
    const SizedBox(height: 100),
    const Divider(thickness: 0.3),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Animate(
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 900)),
            SlideEffect(duration: Duration(milliseconds: 900))
          ],
          child: Text(AppTexts.courses,
              textAlign: TextAlign.center,
              style: Styles.style20White.copyWith(fontSize: 40))),
    ),
    HomeCarousel(
      carouselItem: CarouselItem(
        '${ImageAssets.animationsPath}ai.json',
        AppTexts.aiCourse,
        AppTexts.aiCourseDescription,
      ),
      animateFromLeft: true,
      paragraph: AppTexts.aiCourseParagraph,
    ),
    HomeCarousel(
      carouselItem: CarouselItem(
        '${ImageAssets.animationsPath}cyber.json',
        AppTexts.cyberCourse,
        AppTexts.cyberCourseDescription,
      ),
      animateFromLeft: false,
      paragraph: AppTexts.cyberCourseParagraph,
    ),
    HomeCarousel(
      carouselItem: CarouselItem(
        '${ImageAssets.animationsPath}algo.json',
        AppTexts.algoCourse,
        AppTexts.algoCourseDescription,
      ),
      animateFromLeft: true,
      paragraph: AppTexts.algoCourseParagraph,
    ),
    HomeCarousel(
      carouselItem: CarouselItem(
        '${ImageAssets.animationsPath}project_management.json',
        AppTexts.projectManagementCourse,
        AppTexts.projectManagementCourseDescription,
      ),
      animateFromLeft: false,
      paragraph: AppTexts.projectManagementCourseParagraph,
    ),
    HomeCarousel(
      carouselItem: CarouselItem(
        '${ImageAssets.animationsPath}cs.json',
        AppTexts.csCourse,
        AppTexts.csCourseDescription,
      ),
      animateFromLeft: true,
      paragraph: AppTexts.csCourseParagraph,
    ),
    HomeCarousel(
      carouselItem: CarouselItem(
        '${ImageAssets.animationsPath}photoshop.json',
        AppTexts.photoshopCourse,
        AppTexts.photoshopCourseDescription,
      ),
      animateFromLeft: false,
      paragraph: AppTexts.photoshopCourseParagraph,
    ),
    const Divider(thickness: 0.3),
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
        child: Animate(
            effects: const [
              FadeEffect(duration: Duration(milliseconds: 900)),
              SlideEffect(duration: Duration(milliseconds: 900))
            ],
            child: Text(AppTexts.services,
                textAlign: TextAlign.center,
                style: Styles.style20White.copyWith(fontSize: 40)))),
    const ServicesSectionScreen(),
    const Divider(thickness: 0.3),
    const SizedBox(height: 70),
    const Divider(thickness: 0.3),
    Animate(
        effects: const [
          FadeEffect(duration: Duration(milliseconds: 900)),
          SlideEffect(duration: Duration(milliseconds: 900))
        ],
        child: Text(AppTexts.testimonials,
            textAlign: TextAlign.center,
            style: Styles.style20White.copyWith(fontSize: 40))),
    const TestimonialsScreen(),
    const SizedBox(height: 70),
    const Divider(thickness: 0.3),
    const FooterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeIn,
          );
        },
        child: const Icon(Icons.arrow_upward, color: AppColors.primaryColor),
      ),
      body: Stack(
        children: [
          GradientContainer(
            firstGradientColor: AppColors.greenColor,
            secondGradientColor: AppColors.primaryColor,
            thirdGradientColor: AppColors.secondaryColor,
            myChild: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _widgets.length,
                      itemBuilder: (context, index) {
                        return _widgets[index];
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
