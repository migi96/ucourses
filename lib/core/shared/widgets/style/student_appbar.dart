import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/util/auth_utils.dart';

import '../../../../features/admin/presentation/functions/logout_confirmation.dart';

List<Widget> studentAppBarActions(BuildContext context) {
  return [
    TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/courses'),
      child: Text(AppTexts.courses, style: Styles.style16White),
    ),
    TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/student_profile'),
      child: Text(AppTexts.profile, style: Styles.style16White),
    ),
    TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/completed_courses'),
      child: Text(AppTexts.completedCourses, style: Styles.style16White),
    ),
    TextButton(
      onPressed: () =>
          showLogoutConfirmationDialog(context, () => logout(context)),
      child: Text(AppTexts.logout, style: Styles.style16White),
    ),
  ];
}
