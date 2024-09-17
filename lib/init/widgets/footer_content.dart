

import 'package:flutter/material.dart';

import 'app_policy.dart';
import 'contact_info.dart';
import 'soical_meda_links.dart';

class FooterContent extends StatelessWidget {
  const FooterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
      children:<Widget>[
        ContactInfo(),
        SocialMediaLinks(),
        CustomPolicy(),
      ],
    );
  }
}
