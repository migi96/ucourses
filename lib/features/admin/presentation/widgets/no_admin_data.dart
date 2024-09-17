import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_text.dart';
import '../../../../core/constants/app_text_styles.dart';

class NoAdminData extends StatelessWidget {
  final void Function()? onPressed;
  const NoAdminData({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LottieBuilder.asset(
          'lib/assets/jsons/animation/no-data.json',
          height: 180,
          width: 180,
        ),
        const Text(
          AppTexts.noCourseAvailable,
          style: Styles.style14Red,
        ),
        IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 40,
            ),
            onPressed: onPressed)

        // BlocProvider.of<AdminCubit>(context).getCourses(),
      ],
    );
  }
}
