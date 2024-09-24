import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/constants_exports.dart';

class HomeNavigation extends StatefulWidget {
  final List<NavigationItem> navItems; // List of dynamic items
  const HomeNavigation({super.key, required this.navItems});

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
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

          // Dynamic Navigation buttons
          Expanded(
            child: screenWidth > 600
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.navItems.map((item) {
                      return Row(
                        children: [
                          buildTextButton(
                            context: context,
                            text: item.title,
                            isHovered: item.isHovered,
                            onHover: (hovered) {
                              setState(() {
                                item.isHovered = hovered;
                              });
                            },
                            onPressed: item.onPressed,
                          ),
                          buildVerticalLine(screenWidth),
                        ],
                      );
                    }).toList(),
                  )
                : PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (value) {
                      widget.navItems
                          .firstWhere((item) => item.title == value)
                          .onPressed();
                    },
                    itemBuilder: (context) => widget.navItems
                        .map((item) => PopupMenuItem(
                              value: item.title,
                              child: Text(item.title),
                            ))
                        .toList(),
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
                text,
                overflow: TextOverflow.ellipsis,
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

class NavigationItem {
  final String title;
  bool isHovered;
  final VoidCallback onPressed;

  NavigationItem({
    required this.title,
    required this.onPressed,
    this.isHovered = false,
  });
}
