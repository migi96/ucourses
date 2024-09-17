// contact_info.dart
import 'package:flutter/material.dart';

import '../../core/shared/widgets/decorators/index.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientContainer(
      myHeight: 100,
      firstGradientColor: Colors.blue,
      secondGradientColor: Colors.blueGrey,
      myChild: Center(
        child: Text(
          'Contact Us: contact@example.com',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
