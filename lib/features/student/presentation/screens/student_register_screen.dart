import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/constants_exports.dart';
import '../../../../core/shared/widgets/decorators/index.dart';
import '../../../../core/shared/widgets/style/custom_input_field.dart';
import '../../../../core/util/form_validator.dart';
import '../../../../init/widgets/widget_exports.dart';
import '../../../admin/presentation/screens/admin_profile_screen.dart';
import '../../../admin/presentation/screens/admin_student_list_screen.dart';
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
  final TextEditingController universityNumberController =
      TextEditingController(); // New controller
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isHoveredButton = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    universityNumberController.dispose(); // Dispose the new controller
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        myHeight: MediaQuery.of(context).size.height,
        firstGradientColor: AppColors.primaryColor,
        secondGradientColor: AppColors.secondaryColor,
        myChild: BlocListener<StudentCubit, StudentState>(
          listener: (context, state) {
            if (state is StudentRegistered) {
              Navigator.pushReplacementNamed(context, '/courses');
            } else if (state is StudentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Column(
            children: [
              HomeNavigation(
                navItems: [
                  NavigationItem(
                    title: "الدورات",
                    onPressed: () {
                      // Stay on the same screen (courses)
                    },
                  ),
                  NavigationItem(
                    title: "الطلاب",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminStudentListScreen()));
                    },
                  ),
                  NavigationItem(
                    title: "الملف الشخصي",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminProfileScreen()));
                    },
                  ),
                  NavigationItem(
                    title: "تسجيل الخروج",
                    onPressed: () {
                      // logout(context);
                    },
                  ),
                ],
              ),
              Stack(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  maxRadius: 50,
                                  child: SvgPicture.asset(
                                      '${ImageAssets.imagePath}logo.svg',
                                      height: 60,
                                      width: 60),
                                ),
                                const SizedBox(height: 20),
                                _buildUsernameField(),
                                const SizedBox(height: 16),
                                _buildEmailField(),
                                const SizedBox(height: 16),
                                _buildUniversityNumberField(), // University number field
                                const SizedBox(height: 16),
                                _buildPasswordField(),
                                const SizedBox(height: 16),
                                _buildConfirmPasswordField(),
                                const SizedBox(height: 30),
                                _buildRegisterButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Add a loading overlay if necessary
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the username field
  Widget _buildUsernameField() {
    return CustomInputField(
      controller: usernameController,
      labelText: AppTexts.userName,
      validator: FormValidator.validateUsername,
      prefixIcon: Icons.person,
      suffixIconData: Icons.clear,
      onClearButtonPressed: () => usernameController.clear(),
    );
  }

  // Build the email field
  Widget _buildEmailField() {
    return CustomInputField(
      controller: emailController,
      labelText: AppTexts.email,
      validator: FormValidator.validateEmail,
      prefixIcon: Icons.email,
      suffixIconData: Icons.clear,
      onClearButtonPressed: () => emailController.clear(),
    );
  }

  // Build the university number field with validation
  Widget _buildUniversityNumberField() {
    return CustomInputField(
      controller: universityNumberController,
      labelText: "رقم الجامعة",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'رقم الجامعة مطلوب';
        }
        if (!value.startsWith('44')) {
          return 'رقم الجامعة يجب أن يبدأ بـ 44';
        }
        if (value.length != 9) {
          return 'رقم الجامعة يجب أن يتكون من 9 أرقام';
        }
        return null;
      },
      prefixIcon: Icons.school,
      suffixIconData: Icons.clear,
      onClearButtonPressed: () => universityNumberController.clear(),
      numericKeyboardType: TextInputType.number, // Ensuring numeric input
    );
  }

  // Build the password field
  Widget _buildPasswordField() {
    return CustomInputField(
      controller: passwordController,
      labelText: AppTexts.password,
      validator: FormValidator.validatePassword,
      prefixIcon: Icons.lock,
      obscureText: !_isPasswordVisible,
      suffixIconData:
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      onClearButtonPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }

  // Build the confirm password field
  Widget _buildConfirmPasswordField() {
    return CustomInputField(
      controller: confirmPasswordController,
      labelText: AppTexts.confirmPassword,
      validator: (value) =>
          FormValidator.confirmPassword(passwordController.text, value!),
      prefixIcon: Icons.lock,
      obscureText: !_isConfirmPasswordVisible,
      suffixIconData:
          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
      onClearButtonPressed: () {
        setState(() {
          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
        });
      },
    );
  }

  // Build the register button
  Widget _buildRegisterButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveredButton = true),
      onExit: (_) => setState(() => _isHoveredButton = false),
      child: AnimatedScale(
        scale: _isHoveredButton ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<StudentCubit>(context).register(
                usernameController.text.trim(),
                emailController.text.trim(),
                passwordController.text.trim(),
              );
            }
          },
          icon: const Icon(Icons.how_to_reg),
          label: Text(AppTexts.register, style: Styles.style17),
        ),
      ),
    );
  }
}
