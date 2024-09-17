import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/constants_exports.dart';

class CustomAlertDialog {
  // Function to show a dynamic alert dialog in Arabic
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = 'موافق',
    VoidCallback? onConfirm,
    String? cancelButtonText,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Styles.style18.copyWith(color: Colors.red),
                textDirection: TextDirection.rtl, // Text direction set to RTL
              ),
              const SizedBox(width: 10),
              Lottie.asset('${ImageAssets.animationsPath}error.json',
                  width: 50, height: 50, repeat: false),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  style:
                      Styles.style18.copyWith(color: Colors.grey, fontSize: 16),
                  message,
                  textDirection: TextDirection.rtl, // Text direction set to RTL
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (cancelButtonText != null)
              TextButton(
                onPressed: onCancel ?? () => Navigator.of(context).pop(),
                child: Text(cancelButtonText,
                    style: Styles.style18.copyWith(color: Colors.grey)),
              ),
            TextButton(
              onPressed: onConfirm ?? () => Navigator.of(context).pop(),
              child: Text(confirmButtonText,
                  style:
                      Styles.style18.copyWith(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }
}
