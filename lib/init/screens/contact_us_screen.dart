import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/constants_exports.dart';
import '../../core/shared/widgets/decorators/image_positions_widget.dart'; // Import ImagePositions widget
import '../../features/admin/presentation/screens/admin_profile_screen.dart';
import '../../features/admin/presentation/screens/admin_student_list_screen.dart';
import '../widgets/widget_exports.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  // Track hover state for each icon button
  bool isFacebookHovered = false;
  bool isInstagramHovered = false;
  bool isTwitterHovered = false;
  bool isLinkedInHovered = false;
  bool isGlobeHovered = false;

  // Track hover state for the ElevatedButton
  bool isButtonHovered = false;

  // TextEditingController for input field
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Helper method to launch URL
    void launchWhatsApp() async {
      String message = _messageController.text;
      var whatsappUrl =
          "https://wa.me/966569038850?text=${Uri.encodeComponent(message.isEmpty ? 'أستفسر عن قائمة الشقق' : message)}";
      var uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر فتح WhatsApp'),
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Use ImagePositions for background images
          // Gradient container and other content on top
          GradientContainer(
            firstGradientColor: AppColors.primaryColor,
            secondGradientColor: AppColors.secondaryColor,
            myChild: Stack(
              children: [
                // Lottie animation inside the gradient container, placed at the bottom
                const ImagePositions(
                  imagePath: '${ImageAssets.backgroundImagePath}t_three.png',
                  opacity: 0.05,
                ),
                Column(
                  children: [
                    HomeNavigation(navItems: [
                      NavigationItem(
                        title: AppTexts.home,
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                      ),
                      NavigationItem(
                        title: AppTexts.login,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      NavigationItem(
                        title: AppTexts.about,
                        onPressed: () {
                          Navigator.pushNamed(context, '/about_us');
                        },
                      ),
                      NavigationItem(
                        title: AppTexts.contactUs,
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact_us');
                        },
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.08,
                        horizontal: MediaQuery.of(context).size.width * 0.2,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // GridView with two containers
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  children: [
                                    // Left container with text and social media icons
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: Colors.white,
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const ContactUsIcons(),
                                          const SizedBox(height: 90),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              'إذا كان لديك أي استفسارات، فلا تتردد في التواصل معنا عبر WhatsApp. سنرد عليك في أسرع وقت ممكن.',
                                              style:
                                                  Styles.style20White.copyWith(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          // Social media icons with hover effects
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildIconButton(
                                                context: context,
                                                icon:
                                                    FontAwesomeIcons.facebookF,
                                                color: Colors.blue,
                                                url:
                                                    'https://www.facebook.com/tvtcweb/?locale=ar_AR',
                                                isHovered: isFacebookHovered,
                                                onHover: (hovered) {
                                                  setState(() {
                                                    isFacebookHovered = hovered;
                                                  });
                                                },
                                              ),
                                              buildIconButton(
                                                context: context,
                                                icon:
                                                    FontAwesomeIcons.instagram,
                                                color: Colors.pinkAccent,
                                                url:
                                                    'https://www.instagram.com/tvtc_web/?hl=ar',
                                                isHovered: isInstagramHovered,
                                                onHover: (hovered) {
                                                  setState(() {
                                                    isInstagramHovered =
                                                        hovered;
                                                  });
                                                },
                                              ),
                                              buildIconButton(
                                                context: context,
                                                icon: FontAwesomeIcons.twitter,
                                                color: Colors.blueAccent,
                                                url:
                                                    'https://x.com/tvtcweb?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor',
                                                isHovered: isTwitterHovered,
                                                onHover: (hovered) {
                                                  setState(() {
                                                    isTwitterHovered = hovered;
                                                  });
                                                },
                                              ),
                                              buildIconButton(
                                                context: context,
                                                icon: FontAwesomeIcons.linkedin,
                                                color: Colors.blue,
                                                url:
                                                    'https://www.linkedin.com/school/tvtc/',
                                                isHovered: isLinkedInHovered,
                                                onHover: (hovered) {
                                                  setState(() {
                                                    isLinkedInHovered = hovered;
                                                  });
                                                },
                                              ),
                                              buildIconButton(
                                                context: context,
                                                icon: FontAwesomeIcons.globe,
                                                color: Colors.green,
                                                url:
                                                    'https://lms.elearning.edu.sa/webapps/login/',
                                                isHovered: isGlobeHovered,
                                                onHover: (hovered) {
                                                  setState(() {
                                                    isGlobeHovered = hovered;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    GradientContainer(
                                      firstGradientColor: AppColors.thirdColor,
                                      secondGradientColor:
                                          AppColors.secondaryColor,
                                      myContainerBorderRadius:
                                          const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      myChild: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                maxRadius: 50,
                                                child: SvgPicture.asset(
                                                  '${ImageAssets.imagePath}logo.svg',
                                                  height: 60,
                                                  width: 60,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text(
                                                AppTexts.appName,
                                                style: Styles.style20White
                                                    .copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 60),
                                              TextField(
                                                controller: _messageController,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.message,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    color: Colors.white,
                                                    onPressed: () =>
                                                        _messageController
                                                            .clear(),
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  hintText: 'رسالتك',
                                                  labelText: 'أدخل رسالتك',
                                                  labelStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 2),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 60),
                                              MouseRegion(
                                                onEnter: (_) => setState(() {
                                                  isButtonHovered = true;
                                                }),
                                                onExit: (_) => setState(() {
                                                  isButtonHovered = false;
                                                }),
                                                child: AnimatedScale(
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  scale: isButtonHovered
                                                      ? 1.2
                                                      : 1.0,
                                                  child: ElevatedButton(
                                                    onPressed: launchWhatsApp,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          isButtonHovered
                                                              ? AppColors
                                                                  .primaryColor
                                                              : Colors.white,
                                                    ),
                                                    child: Text(
                                                      'ارسال',
                                                      style: Styles.style20White
                                                          .copyWith(
                                                        fontSize: 14,
                                                        color: isButtonHovered
                                                            ? Colors.white
                                                            : AppColors
                                                                .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String url,
    required bool isHovered,
    required Function(bool) onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isHovered ? 1.2 : 0.8, // Scale factor for hover effect
            child: IconButton(
              icon: FaIcon(icon),
              color: color,
              iconSize: 40,
              onPressed: () {
                var uri = Uri.parse(url);
                launchUrl(uri);
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: 50,
            color: isHovered ? color : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
