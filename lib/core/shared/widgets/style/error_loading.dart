import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/constants_exports.dart';
import '../../../../core/shared/widgets/decorators/index.dart';

class ErrorLoading extends StatelessWidget {
  const ErrorLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        maxRadius: 90,
        backgroundColor: Colors.white,
        child: Lottie.asset(
          '${ImageAssets.animationsPath}error.json',
          height: 100, // Lottie animation path
          width: 100,
        ),
      ),
    );
  }
}
