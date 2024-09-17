import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_colors.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/init/widgets/logo_shadow.dart';

import '../widgets/widget_exports.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Map<String, String>> logos;
  late int totalLogos;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();

    logos = [
      {'image': 'lib/assets/images/icons/ksa-logo.png', 'name': AppTexts.ksa},
      {
        'image': 'lib/assets/images/icons/vision2030-logo.jpg',
        'name': AppTexts.vision
      },
      {'image': 'lib/assets/images/icons/moe-logo.png', 'name': AppTexts.moe},
      {
        'image': 'lib/assets/images/icons/colleage-logo.jpg',
        'name': AppTexts.colleage
      },
      {
        'image': 'lib/assets/images/icons/sdaia-logo.png',
        'name': AppTexts.sdaia
      },
      {'image': 'lib/assets/images/icons/dga-logo.jpg', 'name': AppTexts.dga},
    ];
    totalLogos = logos.length; // Initialize totalLogos
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedLogo(
      Map<String, String> logo, int index, int totalItems) {
    double start = index / totalItems;
    double end = (index + 1) / totalItems;
    end = end > 1.0 ? 1.0 : end; // Ensure end is not greater than 1.0

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(start, end, curve: Curves.easeInOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        )),
        child: LogoShadow(
          logoImage: logo['image']!,
          companyName: logo['name']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        myHeight: double.infinity - 60,
        myWidth: double.infinity - 60,
        firstGradientColor: AppColors.primaryColor,
        secondGradientColor: AppColors.secondaryColor,
        myChild: SingleChildScrollView(
          child: Column(
            children: [
              const HomeNavigation(),
              Card(
                margin: const EdgeInsets.only(
                    left: 50, right: 50, top: 100, bottom: 70),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 80, right: 80, bottom: 20, top: 40),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAnimatedLogo({
                            'image': 'lib/assets/images/icons/logo.png',
                            'name': AppTexts.appName
                          }, 0, totalLogos + 3),
                          const SizedBox(height: 30),
                          _buildAnimatedText(
                              AppTexts.aboutContent, 1, totalLogos + 3),
                          const SizedBox(height: 40),
                          Wrap(
                            spacing: 60,
                            runSpacing: 20,
                            children: List.generate(logos.length, (index) {
                              return _buildAnimatedLogo(
                                  logos[index],
                                  index + 2,
                                  totalLogos +
                                      3); // Start index offset by 2 due to previous widgets
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text, int index, int totalItems) {
    double start = index / totalItems;
    double end = (index + 1) / totalItems;
    end = end > 1.0 ? 1.0 : end;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(start, end, curve: Curves.easeInOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        )),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Styles.style18.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
