// social_media_links.dart
import 'package:flutter/material.dart';

import '../../core/shared/widgets/decorators/index.dart';

class SocialMediaLinks extends StatelessWidget {
  const SocialMediaLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientContainer(
      myHeight: 100,
      firstGradientColor: Colors.deepOrange,
      secondGradientColor: Colors.orange,
      myChild: Center(
        child: Text(
          'Follow us on social media!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
