import 'package:flutter/material.dart';
import '../../core/constants/constants_exports.dart';
import '../../core/shared/widgets/style/animate_lottie.dart';

class ContactUsIcons extends StatefulWidget {
  const ContactUsIcons({super.key});

  @override
  _ContactUsIconsState createState() => _ContactUsIconsState();
}

class _ContactUsIconsState extends State<ContactUsIcons> {
  // Track hover state for each icon
  bool isFirstHovered = false;
  bool isSecondHovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildLottieCard(
          animationPath: '${ImageAssets.animationsPath}responce_time.json',
          isHovered: isFirstHovered,
          onHover: (hovered) {
            setState(() {
              isFirstHovered = hovered;
            });
          },
          title: 'استجابة سريعة',
          subtitle: 'نرد في غضون دقائق',
        ),
        buildLottieCard(
          animationPath: '${ImageAssets.animationsPath}working_hours.json',
          isHovered: isSecondHovered,
          onHover: (hovered) {
            setState(() {
              isSecondHovered = hovered;
            });
          },
          title: 'ساعات العمل',
          subtitle: 'متاح 9 صباحًا - 6 مساءً',
        ),
      ],
    );
  }

  Widget buildLottieCard({
    required String animationPath,
    required bool isHovered,
    required Function(bool) onHover,
    required String title,
    required String subtitle,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Column(
        children: [
          AnimatedLottie(
            animationPath: animationPath,
            isHovered: isHovered,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Styles.style20White
                .copyWith(fontSize: 20, color: AppColors.primaryColor),
          ),
          Text(
            subtitle,
            style:
                Styles.style20White.copyWith(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
