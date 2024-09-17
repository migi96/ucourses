import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ucourses/init/home_screen.dart';
import 'package:ucourses/init/screens/about_screen.dart';
import 'package:ucourses/init/screens/contact_us_screen.dart';
import '../../core/constants/constants_exports.dart';
import '../../core/shared/widgets/decorators/index.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_login_screen.dart'; // Make sure to include url_launcher package

class FooterScreen extends StatefulWidget {
  const FooterScreen({super.key});

  @override
  _FooterScreenState createState() => _FooterScreenState();
}

class _FooterScreenState extends State<FooterScreen> {
  // Track hover state for each button
  bool isAboutHovered = false;
  bool isContactUsHovered = false;
  bool isLoginHovered = false;
  bool isHomeHovered = false;
  bool isFacebookHovered = false;
  bool isInstagramHovered = false;
  bool isTwitterHovered = false;
  bool isGoogleHovered = false;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      firstGradientColor: Colors.white,
      secondGradientColor: Colors.white,
      myChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Social Media Icons Row
          const SizedBox(height: 15), // Space between icons and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildIconButton(
                icon: FontAwesomeIcons.facebookF,
                color: Colors.blue,
                isHovered: isFacebookHovered,
                onHover: (hovered) {
                  setState(() {
                    isFacebookHovered = hovered;
                  });
                },
                onPressed: () {/* Handle your onPressed */},
              ),
              buildIconButton(
                icon: FontAwesomeIcons.instagram,
                color: Colors.pink,
                isHovered: isInstagramHovered,
                onHover: (hovered) {
                  setState(() {
                    isInstagramHovered = hovered;
                  });
                },
                onPressed: () {/* Handle your onPressed */},
              ),
              buildIconButton(
                icon: FontAwesomeIcons.twitter,
                color: Colors.lightBlue,
                isHovered: isTwitterHovered,
                onHover: (hovered) {
                  setState(() {
                    isTwitterHovered = hovered;
                  });
                },
                onPressed: () {/* Handle your onPressed */},
              ),
              buildIconButton(
                icon: FontAwesomeIcons.google,
                color: Colors.red,
                isHovered: isGoogleHovered,
                onHover: (hovered) {
                  setState(() {
                    isGoogleHovered = hovered;
                  });
                },
                onPressed: () {/* Handle your onPressed */},
              ),
            ],
          ),
          const SizedBox(height: 20), // Space between icons and navigation

          // Navigation Links Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ContactUsScreen(),
                    ),
                  );
                },
              ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MainLoginScreen(),
                    ),
                  );
                },
              ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10), // Space between navigation and privacy

          const Divider(
            indent: 100,
            endIndent: 100,
            height: 10,
            thickness: 0.3,
            color: Colors.grey,
          ),
          const SizedBox(height: 10), // Space between navigation and privacy

          // Privacy Policy and Contact Us Info Row
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Privacy Policy Brief
                      Text(
                        '''سياسة الخصوصية: نحن ملتزمون بحماية خصوصيتك.
                                             ...للمزيد من التفاصيل''',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomeScreen(), // Replace with your privacy screen
                            ),
                          );
                        },
                        child: const Text(
                          '''                                                                       المزيد''',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const VerticalDivider(
                width: 10,
                thickness: 5,
                color: Colors.grey,
              ),
              // Vertical Divider
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Contact Us Details
                  Text(
                    'للتواصل معنا:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[800], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        'الهاتف: 0112896666',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        'الفاكس: +123 456 780',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        FontAwesomeIcons.fax,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          launchGoogleMaps();
                        },
                        child: Text(
                          ' الخرج، طريق الملك عبدالله.',
                          style: Styles.style20White.copyWith(
                              fontSize: 15, color: AppColors.primaryColor),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        ':الموقع',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 40),
              const VerticalDivider(
                width: 10,
                thickness: 5,
                color: Colors.grey,
              ),
              const SizedBox(width: 100),
            ],
          ),

          const SizedBox(height: 20), // Space between sections

          const Divider(
            indent: 100,
            endIndent: 100,
            height: 10,
            thickness: 0.3,
            color: Colors.grey,
          ),

          // Copyright Brief
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const HomeScreen(), // Replace with your copyWrite screen
                    ),
                  );
                },
                child: const Text(
                  'المزيد',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
              Text(
                'حقوق النشر ©2024؛ جميع الحقوق محفوظة. للمزيد من التفاصيل...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    required Color color,
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
          // Scale animation for icon
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isHovered ? 1.3 : 1.0, // Scale factor for hover effect
            child: IconButton(
              icon: FaIcon(icon, color: color),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextButton({
    required BuildContext context,
    required String text,
    required bool isHovered,
    required Function(bool) onHover,
    required VoidCallback onPressed,
  }) {
    // Determine the color based on the hover state
    final Color textColor = isHovered
        ? AppColors.primaryColor
        : AppColors.primaryColor.withOpacity(0.9);

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scale animation for text
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isHovered ? 1.1 : 0.8, // Scale factor for hover effect
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: Styles.style20White.copyWith(color: textColor
                    // AppColors.primaryColor, // Change text color dynamically
                    ),
              ),
            ),
          ),
          // Animated line below the text
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: isHovered ? 30 : 0, // Animate line width based on hover
            color: isHovered
                ? AppColors.primaryColor
                : Colors.transparent, // Animate line color
          ),
        ],
      ),
    );
  }

  void launchGoogleMaps() async {
    const String url = 'https://maps.app.goo.gl/L9gGqgzKfPpC1USC8?g_st=ac';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // Handle the error if Google Maps can't be opened
        throw 'Could not launch $url';
      }
    } catch (e) {
      // Handle error, show a message to the user or log it
      print('Error launching Google Maps: $e');
    }
  }
}
