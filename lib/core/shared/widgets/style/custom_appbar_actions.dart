
import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/util/auth_utils.dart';

import '../../../../features/admin/presentation/functions/logout_confirmation.dart';

List<Widget> customAppBarActions(BuildContext context) {
  return [
    TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/admin_courses'),
      child: Text(AppTexts.courses, style: Styles.style16White),
    ),
    TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/admin_students'),
      child: Text(AppTexts.studentlist, style: Styles.style16White),
    ),
    TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/admin_profile'),
      child: Text(AppTexts.adminProfile, style: Styles.style16White),
    ),
    TextButton(
      onPressed: () => showLogoutConfirmationDialog(context, () => logout(context)),
      child: Text(AppTexts.logout, style: Styles.style16White),
    ),
  ];
}
