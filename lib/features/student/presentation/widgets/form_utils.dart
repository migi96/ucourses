import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/shared/widgets/dialogs/custom_alert_dialog.dart';

class LoginFormUtils {
  // Save credentials based on user type (student/admin)
  Future<void> saveCredentials(
      String email, String password, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${userType}_email', email);
    await prefs.setString('${userType}_password', password);
  }

  // Save login state for a specific user type
  Future<void> saveLoginState(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${userType}_isLogged', true);
  }

  // Load credentials into TextControllers for a specific user type
  Future<void> loadCredentials(TextEditingController emailController,
      TextEditingController passwordController, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('${userType}_email') ?? "";
    passwordController.text = prefs.getString('${userType}_password') ?? "";
  }

  // Validator for email field
  String? validateEmailField(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      CustomAlertDialog.showAlertDialog(
        context: context,
        title: AppTexts.error,
        message: AppTexts.emailEmpty,
      );
      return '';
    }
    String pattern = r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return AppTexts.emailInvalid;
    }
    return null;
  }

  // Validator for password field
  String? validatePasswordField(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      CustomAlertDialog.showAlertDialog(
        context: context,
        title: AppTexts.error,
        message: AppTexts.passwordEmpty,
      );
      return '';
    }
    if (value.length < 6) {
      return AppTexts.passwordTooShort;
    }
    return null;
  }
}
