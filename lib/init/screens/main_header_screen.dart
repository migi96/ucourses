import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/constants_exports.dart';
import '../../core/shared/widgets/decorators/image_positions_widget.dart';
import '../widgets/widget_exports.dart';

class MainHeaderScreen extends StatefulWidget {
  const MainHeaderScreen({super.key});

  @override
  State<MainHeaderScreen> createState() => _MainHeaderScreenState();
}

class _MainHeaderScreenState extends State<MainHeaderScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<double> _descOpacity;

  @override
  bool get wantKeepAlive => true; // Keeps state alive

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    setupAnimations();
    _controller.forward();
  }

  void setupAnimations() {
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.60, curve: Curves.easeIn),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.80, curve: Curves.easeIn),
      ),
    );
    _descOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        // Use the new ImagePositions widget for the background images
        const ImagePositions(
          imagePath: '${ImageAssets.backgroundImagePath}t_background.png',
          opacity: 0.05, // Adjust opacity if needed
        ),
        // Main content
        SingleChildScrollView(
          // Wrap in a scroll view for safety
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 80,
                color: Colors.white.withOpacity(0.1),
                child: const HomeNavigation(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                height: MediaQuery.of(context).size.height *
                    0.6, // Constrain height
                alignment: Alignment.center,
                width: double.infinity,
                child: buildStack(),
              ),
              const SizedBox(height: 30), // Add some padding at the bottom
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStack() {
    return AnimatedCircleContainer(
      animationDuration: const Duration(milliseconds: 1600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Keep the column as small as possible
        children: [
          const SizedBox(
            width: double.infinity,
            height: 15,
          ),
          // Logo
          SvgPicture.asset('${ImageAssets.imagePath}logo.svg',
              height: 100, width: 100),
          const SizedBox(height: 20), // Adjust space between items
          // Welcome Title
          FadeTransition(
            opacity: _titleOpacity,
            child: Text(
              AppTexts.welcome,
              textAlign: TextAlign.center,
              style: Styles.styleBold.copyWith(fontSize: 25),
            ),
          ),
          const SizedBox(height: 10),
          // Welcome Description
          FadeTransition(
            opacity: _descOpacity,
            child: Text(
              AppTexts.welcomeDesc,
              textAlign: TextAlign.center,
              style: Styles.style14black.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
