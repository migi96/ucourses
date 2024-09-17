// lib/core/util/form_validator.dart
import '../constants/constants_exports.dart';

class FormValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.emailEmpty;
    }
    String pattern = r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return AppTexts.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.passwordEmpty;
    }
    if (value.length < 6) {
      return AppTexts.passwordTooShort;
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  static String? confirmPassword(String password, String value) {
    if (password != value) {
      return 'Passwords do not match';
    }
    return null;
  }
}
