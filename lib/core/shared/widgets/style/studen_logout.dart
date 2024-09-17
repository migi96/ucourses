import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';

void showStudentLogoutConfirmationDialog(
    BuildContext context, VoidCallback onLogout) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text(
            'تأكيد',
            style: Styles.style18,
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'هل تريد تسجيل الخروج؟',
            style: Styles.style16,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('تسجيل الخروج', style: Styles.style16),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onLogout();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              label: const Text(
                'إلغاء',
                style: Styles.style16,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
}
