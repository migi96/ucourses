import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/app_colors.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_icon.dart';
import 'package:ucourses/core/util/form_validator.dart';
import '../../../../core/shared/widgets/style/custom_input_field.dart';
import '../cubit/student_cubit.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  _StudentRegisterScreenState createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _setUpTextControllerListeners();
  }

  void _setUpTextControllerListeners() {
    emailController.addListener(_onTextControllerChanged);
    passwordController.addListener(_onTextControllerChanged);
    usernameController.addListener(_onTextControllerChanged);
    confirmPasswordController.addListener(_onTextControllerChanged);
  }

  void _onTextControllerChanged() {
    if (emailController.text.isNotEmpty ||
        passwordController.text.isNotEmpty ||
        usernameController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty) {
      _animationController
        ..reset()
        ..forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentCubit = BlocProvider.of<StudentCubit>(context);

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state is StudentRegistered) {
            Navigator.pushReplacementNamed(context, '/courses');
          } else if (state is StudentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Directionality(textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  maxRadius: 55,
                  child: GradientIcon(
                    firstGradientColor: AppColors.primaryColor,
                    secondGradientColor: AppColors.thirdColor,
                    myChild: Hero(
                      tag: 'app-logo',
                      child: Transform.flip(
                        flipX: true,
                        child: Lottie.asset(
                            'lib/assets/jsons/animation/profile.json',
                            controller: _animationController,
                            onLoaded: (composition) {
                          _animationController.duration = composition.duration;
                        }, repeat: false),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  margin: const EdgeInsets.only(
                      top: 30, right: 100, left: 100, bottom: 60),
                  elevation: 15,
                  child: Form(
                    key: _formKey,
                    child: GradientContainer(
                      myHeight: 400,
                      myContainerBorderRadius: BorderRadius.circular(20),
                      firstGradientColor: AppColors.primaryColor,
                      secondGradientColor: AppColors.thirdColor,
                      myChild: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 40, top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomInputField(
                              controller: usernameController,
                              labelText: AppTexts.userName,
                              validator: FormValidator.validateUsername,
                              prefixIcon: Icons.person,
                              suffixIconData: Icons.clear,
                              onClearButtonPressed: () =>
                                  usernameController.clear(),
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              controller: emailController,
                              labelText: AppTexts.email,
                              validator: FormValidator.validateEmail,
                              prefixIcon: Icons.email,
                              suffixIconData: Icons.clear,
                              onClearButtonPressed: () => emailController.clear(),
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              controller: passwordController,
                              labelText: AppTexts.password,
                              validator: FormValidator.validatePassword,
                              prefixIcon: Icons.lock,
                              obscureText: !_isPasswordVisible,
                              suffixIconData: _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onClearButtonPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              controller: confirmPasswordController,
                              labelText: AppTexts.confirmPassword,
                              validator: (value) => FormValidator.confirmPassword(
                                  passwordController.text, value!),
                              prefixIcon: Icons.lock,
                              obscureText: !_isConfirmPasswordVisible,
                              suffixIconData: _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onClearButtonPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  studentCubit.register(
                                    usernameController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                }
                              },
                              icon: const Icon(Icons.how_to_reg),
                              label: Text(
                                AppTexts.register,
                                style: Styles.style17,
                              ),
                            ),
                          ],
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
    );
  }
}
