import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0), // Custom height for AppBar
      child: AppBar(
        
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          title!,
          style: Styles.style20White,
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(60.0); // Custom height for AppBar
}
