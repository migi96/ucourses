import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/constants_exports.dart';
import '../home_screen.dart';
import '../screens/about_screen.dart';
import '../screens/contact_us_screen.dart';
import '../screens/main_login_screen.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  // Track hover state for each button
  bool isHomeHovered = false;
  bool isLoginHovered = false;
  bool isAboutHovered = false;
  bool isContactUsHovered = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust size of images and spacing based on screen size
    double iconSize = screenWidth > 800 ? 90 : 50;
    double padding = screenWidth > 800 ? 50 : 20;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Vision icon on the left
          Row(
            children: [
              SvgPicture.asset(
                '${ImageAssets.imagePath}colleage-logo.svg',
                color: Colors.white.withOpacity(0.3),
                height: iconSize,
                width: iconSize,
              ),
              SizedBox(width: padding),
              Image.asset(
                '${ImageAssets.imagePath}vision.png',
                color: Colors.white.withOpacity(0.3),
                height: iconSize,
                width: iconSize,
              ),
              SizedBox(width: padding),
              Image.asset(
                '${ImageAssets.imagePath}education.png',
                color: Colors.white.withOpacity(0.3),
                height: iconSize,
                width: iconSize,
              ),
            ],
          ),

          // Navigation buttons with animated underline and vertical lines
          Expanded(
            child: screenWidth > 600
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildTextButton(
                        context: context,
                        text: AppTexts.home,
                        isHovered: isHomeHovered,
                        onHover: (hovered) {
                          setState(() {
                            isHomeHovered = hovered;
                          });
                        },
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                        },
                      ),
                      buildVerticalLine(
                          screenWidth), // Responsive vertical line
                      buildTextButton(
                        context: context,
                        text: AppTexts.login,
                        isHovered: isLoginHovered,
                        onHover: (hovered) {
                          setState(() {
                            isLoginHovered = hovered;
                          });
                        },
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MainLoginScreen()));
                        },
                      ),
                      buildVerticalLine(
                          screenWidth), // Responsive vertical line
                      buildTextButton(
                        context: context,
                        text: AppTexts.about,
                        isHovered: isAboutHovered,
                        onHover: (hovered) {
                          setState(() {
                            isAboutHovered = hovered;
                          });
                        },
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AboutScreen()));
                        },
                      ),
                      buildVerticalLine(
                          screenWidth), // Responsive vertical line
                      buildTextButton(
                        context: context,
                        text: AppTexts.contactUs,
                        isHovered: isContactUsHovered,
                        onHover: (hovered) {
                          setState(() {
                            isContactUsHovered = hovered;
                          });
                        },
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ContactUsScreen()));
                        },
                      ),
                    ],
                  )
                : PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (value) {
                      switch (value) {
                        case AppTexts.home:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                          break;
                        case AppTexts.login:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MainLoginScreen()));
                          break;
                        case AppTexts.about:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AboutScreen()));
                          break;
                        case AppTexts.contactUs:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ContactUsScreen()));
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: AppTexts.home,
                        child: Text(AppTexts.home),
                      ),
                      const PopupMenuItem(
                        value: AppTexts.login,
                        child: Text(AppTexts.login),
                      ),
                      const PopupMenuItem(
                        value: AppTexts.about,
                        child: Text(AppTexts.about),
                      ),
                      const PopupMenuItem(
                        value: AppTexts.contactUs,
                        child: Text(AppTexts.contactUs),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Vertical line between buttons
  Widget buildVerticalLine(double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: screenWidth > 800 ? 30 : 20, // Adjust height for responsiveness
      width: screenWidth > 800 ? 1.3 : 1.0, // Adjust thickness
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget buildTextButton({
    required BuildContext context,
    required String text,
    required bool isHovered,
    required Function(bool) onHover,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isHovered ? 1.2 : 1.0, // Scale factor for hover effect
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                overflow: TextOverflow.ellipsis,
                text,
                style: Styles.style24.copyWith(
                  fontSize: 20, // Adjust font size for responsiveness
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: isHovered ? 60 : 0, // Animate line width based on hover
            color: Colors.white, // White line when hovered
          ),
        ],
      ),
    );
  }
}
