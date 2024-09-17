import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/constants_exports.dart';
import '../widgets/line_painter.dart';

class ServicesSectionScreen extends StatefulWidget {
  const ServicesSectionScreen({super.key});

  @override
  State<ServicesSectionScreen> createState() => _ServicesSectionScreenState();
}

class _ServicesSectionScreenState extends State<ServicesSectionScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _lineController;
  late Animation<double> _lineProgress;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _lineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _lineProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );

    _lineController.forward();
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          // Robot Image on the Left
          Positioned(
            left: 0,
            child: Image.asset(
              '${ImageAssets.backgroundImagePath}robotooo.png',

              height:
                  MediaQuery.of(context).size.height * 0.8, // Adjust the size
              fit: BoxFit.contain,
            ),
          ),

          // CustomPainter with animated lines and circles on the right
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.5, // Half of the screen width
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // Dot and lines in the background
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AnimatedBuilder(
                      animation: _lineController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: DotAndLinesPainter(_lineProgress.value),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    right: MediaQuery.of(context).size.width *
                        0.38, // Midpoint between 0.4 and 0.5
                    top: MediaQuery.of(context).size.height * 0.10,
                    child: _buildServiceContainer(
                      'lib/assets/images/icons/first_service.png',
                      AppTexts.serviceOne,
                      AppTexts.serviceOneDesc,
                    ),
                  ),
                  // Service One (Top-left aligned)

                  // Service Two (Top-right aligned)
                  Positioned(
                    right: MediaQuery.of(context).size.width *
                        0.02, // Adjust for spacing
                    top: MediaQuery.of(context).size.height * 0.1,
                    child: _buildServiceContainer(
                      'lib/assets/images/icons/second_service.png',
                      AppTexts.serviceTwo,
                      AppTexts.serviceTwoDesc,
                    ),
                  ),

                  // Service Three (Bottom-right aligned)
                  Positioned(
                    right: MediaQuery.of(context).size.width *
                        0.05, // Adjust for spacing
                    top: MediaQuery.of(context).size.height * 0.50,
                    child: _buildServiceContainer(
                      'lib/assets/images/icons/third_service.png',
                      AppTexts.serviceThree,
                      AppTexts.serviceThreeDesc,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build service container with image, title, and description
  Widget _buildServiceContainer(
      String imageUrl, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade100.withOpacity(0.9),
          maxRadius: 45,
          child: Image.asset(
            imageUrl,
            scale: 8,
          ),
        ),
        const SizedBox(height: 10),
        Animate(
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 800)),
            ScaleEffect(duration: Duration(milliseconds: 800))
          ],
          child: Text(
            title,
            style: Styles.style16Bold
                .copyWith(color: AppColors.primaryColor, fontSize: 23),
          ),
        ),
        const SizedBox(height: 5),
        Animate(
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 800)),
            ScaleEffect(duration: Duration(milliseconds: 800))
          ],
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Styles.style14
                .copyWith(color: Colors.grey.shade600, fontSize: 19),
          ),
        ),
      ],
    );
  }
}
