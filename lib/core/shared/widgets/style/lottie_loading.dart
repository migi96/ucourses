import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/constants_exports.dart';
import '../decorators/index.dart';

class LottieLoading extends StatelessWidget {
  const LottieLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
          child: GradientIcon(
              firstGradientColor: AppColors.primaryColor,
              secondGradientColor: AppColors.secondaryColor,
              myChild:
                  Lottie.asset('lib/assets/jsons/animation/loading.json'))),
    );
  }
}
