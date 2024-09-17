import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/app_colors.dart';
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_icon.dart';
import 'package:ucourses/init/widgets/logo_shadow.dart';
import '../functions/logout_confirmation.dart';
import '../screens/admin_profile_screen.dart';
import '../screens/admin_student_list_screen.dart';

class AdminDrawer extends StatelessWidget {
  final void Function() onLogout;
  const AdminDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const Directionality(
            textDirection: TextDirection.rtl,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoShadow(
                      logoImage: 'lib/assets/images/icons/app-logo.png',
                      companyName: ''),
                  Text(
                    AppTexts.menu,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: GradientIcon(
              firstGradientColor: Colors.orange,
              secondGradientColor: Colors.deepOrange,
              myChild: Lottie.asset('lib/assets/jsons/animation/courses.json',
                  repeat: false),
            ),
            title: const Text(
              AppTexts.courses,
              style: Styles.style16,
            ),
            onTap: () => Navigator.pop(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            horizontalTitleGap: 0.0,
            trailing: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
          ListTile(
            leading: GradientIcon(
              firstGradientColor: Colors.orange,
              secondGradientColor: Colors.deepOrange,
              myChild: Lottie.asset('lib/assets/jsons/animation/students.json',
                  repeat: false),
            ),
            title: const Text(AppTexts.studentlist, style: Styles.style16),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminStudentListScreen())),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            horizontalTitleGap: 0.0,
            trailing: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
          ListTile(
            leading: GradientIcon(
              firstGradientColor: Colors.orange,
              secondGradientColor: Colors.deepOrange,
              myChild: Lottie.asset('lib/assets/jsons/animation/profile.json',
                  repeat: false),
            ),
            title: const Text(AppTexts.profile, style: Styles.style16),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminProfileScreen())),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            horizontalTitleGap: 0.0,
            trailing: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
          ListTile(
            leading: Lottie.asset('lib/assets/jsons/animation/logout.json',
                repeat: false),
            title: const Text(AppTexts.logout, style: Styles.style16),
            onTap: () => showLogoutConfirmationDialog(context, onLogout),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            horizontalTitleGap: 0.0,
            trailing: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
