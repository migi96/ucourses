import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/constants_exports.dart';
import '../../core/shared/widgets/dialogs/custom_alert_dialog.dart';
import '../../core/shared/widgets/style/custom_input_field.dart';
import '../../features/admin/presentation/cubit/admin_auth_cubit.dart';
import '../../features/student/presentation/widgets/form_utils.dart';
import '../../features/student/presentation/widgets/loading_overlay.dart';

class AdminLoginForm extends StatefulWidget {
  final Function(bool) onRememberMeChanged;

  const AdminLoginForm({super.key, required this.onRememberMeChanged});

  @override
  _AdminLoginFormState createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Loading state

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final LoginFormUtils _formUtils =
      LoginFormUtils(); // Instantiate the utility class

  bool _isHoveredEmail = false;
  bool _isHoveredPassword = false;
  bool _isHoveredButton = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Use the loadCredentials method

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
  Widget build(BuildContext context) {
    return BlocListener<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (state == AdminAuthState.authenticated) {
          _saveLoginState(); // Use the saveLoginState method
          Navigator.pushReplacementNamed(context, '/admin_courses');
        } else if (state == AdminAuthState.error) {
          CustomAlertDialog.showAlertDialog(
            context: context,
            title: AppTexts.error,
            message: '${AppTexts.authFailed}, ${AppTexts.tryAgain}',
          );
          setState(() {
            _isLoading = false; // Stop loading on error
          });
        }
      },
      child: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Form(
              key: _formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      _buildRememberMeCheckbox(),
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading) const LoadingOverlay(), // Refactored loading overlay
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveredEmail = true),
      onExit: (_) => setState(() => _isHoveredEmail = false),
      child: AnimatedScale(
        scale: _isHoveredEmail ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: CustomInputField(
          controller: emailController,
          labelText: AppTexts.email,
          validator: (value) => _formUtils.validateEmailField(
              context, value), // Use utility for validation
          prefixIcon: Icons.email,
          suffixIconData: Icons.clear,
          onClearButtonPressed: () => emailController.clear(),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveredPassword = true),
      onExit: (_) => setState(() => _isHoveredPassword = false),
      child: AnimatedScale(
        scale: _isHoveredPassword ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: CustomInputField(
          controller: passwordController,
          labelText: AppTexts.password,
          validator: (value) => _formUtils.validatePasswordField(
              context, value), // Use utility for validation
          prefixIcon: Icons.lock,
          obscureText: !_isPasswordVisible,
          suffixIconData:
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          onClearButtonPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor:
              WidgetStateProperty.all(AppColors.thirdColor.withOpacity(0.8)),
          value: _rememberMe,
          onChanged: (bool? value) {
            setState(() {
              _rememberMe = value ?? false;
            });
            widget.onRememberMeChanged(value ?? false);
          },
        ),
        Text(AppTexts.rememberUser, style: Styles.style16White),
      ],
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveredButton = true),
      onExit: (_) => setState(() => _isHoveredButton = false),
      child: AnimatedScale(
        scale: _isHoveredButton ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            elevation: _isHoveredButton ? 15 : 5,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isLoading = true;
              });
              if (_rememberMe) {
                _formUtils.saveCredentials(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  'admin',
                );
              }
              context.read<AdminAuthCubit>().authenticateAdmin(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
            }
          },
          icon: const Icon(Icons.login, color: AppColors.thirdColor),
          label: Text(
            AppTexts.login,
            style: Styles.style20White.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> _saveLoginState() async =>
      _formUtils.saveLoginState('admin'); // Use the utility method

  Future<void> _loadCredentials() async => _formUtils.loadCredentials(
      emailController, passwordController, 'admin'); // Use the utility method
}
