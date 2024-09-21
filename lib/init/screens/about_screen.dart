import 'package:flutter/material.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/init/screens/footer_screen.dart';
import 'package:ucourses/init/widgets/logo_shadow.dart';

import '../../core/constants/constants_exports.dart';
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
      duration: const Duration(seconds: 8), // Slower animation
      vsync: this,
    )..forward();

    logos = [
      {'image': 'lib/assets/images/icons/logo.png', 'name': AppTexts.appName},
      {'image': 'lib/assets/images/icons/ksa-logo.png', 'name': AppTexts.ksa},
      {'image': 'lib/assets/images/icons/vision.png', 'name': AppTexts.vision},
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
          begin: const Offset(1, 0), // Slide in from the right
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        )),
        child: SizedBox(
          width: 140, // Smaller logo size
          height: 140,
          child: LogoShadow(
            height: 55,
            width: 55,
            logoImage: logo['image']!,
            companyName: logo['name']!,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        myHeight: double.infinity,
        myWidth: double.infinity,
        firstGradientColor: AppColors.primaryColor,
        secondGradientColor: AppColors.secondaryColor,
        myChild: SingleChildScrollView(
          child: Column(
            children: [
              const HomeNavigation(),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: Image.asset(
                        '${ImageAssets.backgroundImagePath}about_us_background.png',
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 80, right: 80, top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Animated Text in the center
                                  _buildAnimatedText(
                                      AppTexts.aboutContent, 1, totalLogos + 3),
                                  const SizedBox(height: 40),
                                  // Logos (including app logo) at the bottom-right in a row
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          List.generate(logos.length, (index) {
                                        return _buildAnimatedLogo(
                                            logos[index],
                                            index + 2,
                                            totalLogos +
                                                3); // Logos with slide animation
                                      }),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const GradientContainer(
                firstGradientColor: AppColors.primaryColor,
                secondGradientColor: AppColors.secondaryColor,
                myWidth: double.infinity,
                myHeight: 60,
              ),
              const FooterScreen()
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
          begin: const Offset(1, 0), // Slide from the right
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        )),
        child: Align(
          alignment: Alignment.centerRight, // Align the text to the right
          child: Padding(
            padding:
                const EdgeInsets.only(right: 30.0), // Add padding to the right
            child: Text(
              text,
              textAlign: TextAlign.right, // Text aligned to the right
              style: Styles.style18.copyWith(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
