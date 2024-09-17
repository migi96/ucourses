import 'package:flutter/material.dart';
import '../../core/constants/constants_exports.dart';

class HelperWidgets {
  static Widget buildTypingParagraph(String paragraph, bool animateFromLeft,
      Animation<Offset> slideAnimationParagraph, BuildContext context) {
    return SlideTransition(
      position: slideAnimationParagraph,
      child: Container(
        alignment:
            animateFromLeft ? Alignment.centerRight : Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          paragraph,
          style: Styles.style20White, // Removed parentheses here
          textAlign: animateFromLeft ? TextAlign.center : TextAlign.center,
        ),
      ),
    );
  }
}
