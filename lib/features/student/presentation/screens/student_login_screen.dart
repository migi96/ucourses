import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/core/util/form_validator.dart';
import '../../../../core/shared/widgets/style/custom_input_field.dart';
import '../cubit/student_cubit.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocListener<StudentCubit, StudentState>(
          listener: (context, state) {
            if (state is StudentLoggedIn) {
              Navigator.pushReplacementNamed(context, '/courses');
            } else if (state is StudentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                maxRadius: 55,
                child: Hero(
                    tag: 'app-logo',
                    child: Image.asset('lib/assets/images/icons/app-logo.png')),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 30, right: 100, left: 100, bottom: 60),
                child: Form(
                  key: _formKey,
                  child: GradientContainer(
                    myHeight: 330,
                    myContainerBorderRadius: BorderRadius.circular(20),
                    firstGradientColor: AppColors.thirdColor,
                    secondGradientColor: AppColors.primaryColor,
                    myChild: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 40, top: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomInputField(
                              controller: emailController,
                              labelText: AppTexts.email,
                              validator: FormValidator.validateEmail,
                              prefixIcon: Icons.email,
                              suffixIconData: Icons.clear,
                              onClearButtonPressed: () =>
                                  emailController.clear(),
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
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  AppTexts.rememberMe,
                                  style: Styles.style16White,
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_rememberMe) {
                                    _saveCredentials();
                                  }
                                  context.read<StudentCubit>().login(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                }
                              },
                              icon: const Icon(Icons.login),
                              label: Text(
                                AppTexts.login,
                                style: Styles.style17,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text(
                                '${AppTexts.noAccountRegister}${AppTexts.register}',
                                style: Styles.style16White,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
  }

  void _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', true);
  }

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? "";
      passwordController.text = prefs.getString('password') ?? "";
      _rememberMe = prefs.getBool('isLogged') ?? false;
    });
  }
}
