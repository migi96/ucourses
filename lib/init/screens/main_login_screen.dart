import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import '../../core/shared/widgets/decorators/image_positions_widget.dart';
import '../widgets/admin_login_form.dart';
import '../widgets/centered_buttons.dart';
import '../widgets/student_login_form.dart';
import '../widgets/widget_exports.dart';

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({super.key});

  @override
  _MainLoginScreenState createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen>
    with TickerProviderStateMixin {
  bool _isAdminSelected = true; // Tracks which button is selected
  bool _rememberMe = false;
  double _circlePosition = 0;
  Color _containerBorderColor = Colors.transparent;

  late AnimationController _verticalLineController;
  late AnimationController _circleMoveController;
  late Animation<double> _verticalLineAnimation;
  late Animation<double> _circlePositionAnimation;

  @override
  void dispose() {
    _verticalLineController.dispose();
    _circleMoveController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _verticalLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _circleMoveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _circlePositionAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _circleMoveController,
        curve: Curves.easeInOut,
      ),
    );
    _verticalLineAnimation = CurvedAnimation(
      parent: _verticalLineController,
      curve: Curves.easeInOut,
    );
  }

  void _onButtonClick(bool isAdmin) {
    setState(() {
      _isAdminSelected = isAdmin;
      _containerBorderColor = Colors.transparent;
    });

    double targetPosition = isAdmin ? -80 : 80;
    _circlePositionAnimation =
        Tween<double>(begin: _circlePosition, end: targetPosition).animate(
      CurvedAnimation(
        parent: _circleMoveController,
        curve: Curves.easeInOut,
      ),
    );

    _circleMoveController.forward(from: 0).then((_) {
      setState(() {
        _circlePosition = targetPosition;
        _containerBorderColor =
            Colors.white.withOpacity(0.3); // Border turns white after animation
      });
      _verticalLineController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GradientContainer(
        firstGradientColor: AppColors.primaryColor,
        secondGradientColor: AppColors.secondaryColor,
        myHeight: MediaQuery.of(context).size.height,
        myChild: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HomeNavigation(),
              Stack(
                children: [
                  const ImagePositions(
                    imagePath: '${ImageAssets.backgroundImagePath}t_five.png',
                    opacity: 0.05,
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 70,
                              child: SvgPicture.asset(
                                  '${ImageAssets.imagePath}logo.svg',
                                  height: 70,
                                  width: 70),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                CenteredButtons(
                                  onAdminPressed: () => _onButtonClick(true),
                                  onStudentPressed: () => _onButtonClick(false),
                                ),
                                AnimatedBuilder(
                                  animation: _circlePositionAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                          _circlePositionAnimation.value, 0),
                                      child: Column(
                                        children: [
                                          const CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.white,
                                          ),
                                          AnimatedBuilder(
                                            animation: _verticalLineAnimation,
                                            builder: (context, child) {
                                              return Container(
                                                width: 2,
                                                height: 40 *
                                                    _verticalLineAnimation
                                                        .value,
                                                color: Colors.white,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.3,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 4,
                                  blurRadius: 9,
                                  offset: const Offset(-20, 10),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _containerBorderColor, width: 2),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: _isAdminSelected
                                ? AdminLoginForm(onRememberMeChanged: (value) {
                                    setState(() {
                                      _rememberMe = value;
                                    });
                                  })
                                : StudentLoginForm(
                                    onRememberMeChanged: (value) {
                                      setState(() {
                                        _rememberMe = value;
                                      });
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
