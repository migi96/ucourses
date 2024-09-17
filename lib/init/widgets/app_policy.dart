import 'package:flutter/material.dart';

import '../../core/shared/widgets/decorators/index.dart';

class CustomPolicy extends StatelessWidget {
  const CustomPolicy ({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    
     const GradientContainer(
      myHeight: 100,
      firstGradientColor: Colors.green,
      secondGradientColor: Colors.lightGreen,
      myChild: Center(
        child: Text(
          'Privacy Policy | Terms of Service',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
