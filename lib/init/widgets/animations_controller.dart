// animations_controller.dart
import 'package:flutter/animation.dart';

class AnimationControllers {
  // Initialize controllers
  static void initializeControllers({
    required TickerProvider vsync,
    required Function(AnimationController) verticalController,
    required Function(AnimationController) horizontalController,
    required Function(AnimationController) circleFadeController,
  }) {
    verticalController(AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 900),
    ));
    horizontalController(AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2200),
    ));
    circleFadeController(AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    ));
  }

  // Get Fade Animation for Title
  static Animation<double> getFadeAnimationTitle(
      AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );
  }

  // Get Slide Animation for Title
  static Animation<Offset> getSlideAnimationTitle(
      AnimationController controller) {
    return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeInOut),
      ),
    );
  }

  // Get Fade Animation for Description
  static Animation<double> getFadeAnimationDescription(
      AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  // Get Slide Animation for Description
  static Animation<Offset> getSlideAnimationDescription(
      AnimationController controller) {
    return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );
  }

  // Get Line Animation for Vertical Progress
  static Animation<double> getLineAnimationVertical(
      AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  // Get Line Animation for Horizontal Progress
  static Animation<double> getLineAnimationHorizontal(
      AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // Get Circle Fade Animation
  static Animation<double> getCircleFadeAnimation(
      AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // Get Slide Animation for Paragraph
  static Animation<Offset> getSlideAnimationParagraph(
      bool animateFromLeft, AnimationController controller) {
    return Tween<Offset>(
            begin:
                animateFromLeft ? const Offset(0.3, 0) : const Offset(-0.3, 0),
            end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );
  }
}
