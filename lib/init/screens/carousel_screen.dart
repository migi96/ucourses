import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/init/widgets/home_painter.dart';
import 'dart:async';

import '../../core/shared/widgets/decorators/index.dart';
import '../widgets/animations_controller.dart';
import '../widgets/carousel_item.dart';
import '../widgets/paragraph_helper_widgets.dart';

class HomeCarousel extends StatefulWidget {
  final CarouselItem carouselItem;
  final bool animateFromLeft; // To determine the direction of animation
  final String paragraph;

  const HomeCarousel({
    super.key,
    required this.carouselItem,
    required this.animateFromLeft,
    required this.paragraph,
  });

  @override
  _HomeCarouselState createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _verticalController;
  late AnimationController _horizontalController;
  late AnimationController _circleFadeController; // For circle fade animation
  late Animation<double> _fadeAnimationTitle;
  late Animation<Offset> _slideAnimationTitle;
  late Animation<double> _fadeAnimationDescription;
  late Animation<Offset> _slideAnimationDescription;
  late Animation<double> _lineAnimationVertical;
  late Animation<double> _lineAnimationHorizontal;
  late Animation<double> _circleFadeAnimation; // For circle fade effect
  late Animation<Offset> _slideAnimationParagraph;
  String _displayedText = "";
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController and Animations from the separate file
    AnimationControllers.initializeControllers(
      vsync: this,
      verticalController: (controller) => _verticalController = controller,
      horizontalController: (controller) => _horizontalController = controller,
      circleFadeController: (controller) => _circleFadeController = controller,
    );

    _fadeAnimationTitle =
        AnimationControllers.getFadeAnimationTitle(_verticalController);
    _slideAnimationTitle =
        AnimationControllers.getSlideAnimationTitle(_verticalController);
    _fadeAnimationDescription =
        AnimationControllers.getFadeAnimationDescription(_verticalController);
    _slideAnimationDescription =
        AnimationControllers.getSlideAnimationDescription(_verticalController);
    _lineAnimationVertical =
        AnimationControllers.getLineAnimationVertical(_verticalController);
    _lineAnimationHorizontal =
        AnimationControllers.getLineAnimationHorizontal(_horizontalController);

    _circleFadeAnimation =
        AnimationControllers.getCircleFadeAnimation(_circleFadeController);
    _slideAnimationParagraph = AnimationControllers.getSlideAnimationParagraph(
        widget.animateFromLeft, _verticalController);

    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _isVisible = true;
      });

      // Start the circle fade-in animation first
      _circleFadeController.forward().then((_) {
        _verticalController.forward().then((_) {
          _horizontalController.forward().then((_) {
            _animateTyping(widget.paragraph);
          });
        });
      });
    });
  }

  void _animateTyping(String text) {
    int charIndex = 0;
    Timer.periodic(const Duration(milliseconds: 40), (Timer timer) {
      if (charIndex < text.length) {
        setState(() {
          _displayedText += text[charIndex];
          charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose(); // Dispose of the vertical controller
    _horizontalController.dispose(); // Dispose of the horizontal controller
    _circleFadeController.dispose(); // Dispose of the circle fade controller
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // Ensures the widget's state is kept alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures AutomaticKeepAliveClientMixin works
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: MediaQuery.of(context).size.height *
          0.3, // Adjust the height of the container
      child: Stack(
        children: [
          // Custom painted lines with progress animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _lineAnimationVertical,
                _lineAnimationHorizontal,
                _circleFadeAnimation
              ]),
              builder: (context, child) {
                return CustomPaint(
                  painter: LinePainter(
                    animateFromLeft: widget.animateFromLeft,
                    progressVertical: _lineAnimationVertical.value,
                    progressHorizontal: _lineAnimationHorizontal.value,
                    circleOpacity: _circleFadeAnimation.value,
                  ),
                );
              },
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 4200),
            curve: Curves.easeInOut,
            left: widget.animateFromLeft
                ? _isVisible
                    ? screenWidth * 0.07
                    : -screenWidth
                : null,
            right: widget.animateFromLeft
                ? null
                : _isVisible
                    ? screenWidth * 0.07
                    : -screenWidth,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _isVisible ? 1.0 : 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.animateFromLeft
                    ? [
                        _buildCarouselItem(widget.carouselItem),
                        SizedBox(width: screenWidth * 0.08),
                        _buildTypingParagraph(_displayedText),
                      ]
                    : [
                        _buildTypingParagraph(_displayedText),
                        SizedBox(width: screenWidth * 0.08),
                        _buildCarouselItem(widget.carouselItem),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItem item) {
    const sizedBox = const SizedBox(height: 10);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          margin: const EdgeInsets.only(top: 40, bottom: 40),
          color: Colors.transparent,
          elevation: 3,
          child: Container(
            width: 400, // Set a fixed width for the container
            height: 250, // Set a fixed height for the container
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GradientIcon(
                      firstGradientColor: Colors.white,
                      secondGradientColor: Colors.white,
                      myChild: Lottie.asset(
                        item.imageUrl,
                        fit: BoxFit.contain,
                        height: 120,
                        width: 120,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimationTitle,
                        child: SlideTransition(
                          position: _slideAnimationTitle,
                          child: Text(
                            item.title,
                            style: Styles.style20White.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      sizedBox,
                      FadeTransition(
                        opacity: _fadeAnimationDescription,
                        child: SlideTransition(
                          position: _slideAnimationDescription,
                          child: Text(
                            item.description,
                            style: Styles.style20White.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingParagraph(String paragraph) {
    return HelperWidgets.buildTypingParagraph(
        paragraph, widget.animateFromLeft, _slideAnimationParagraph, context);
  }
}
