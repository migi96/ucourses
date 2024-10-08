import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get topPadding => MediaQuery.of(this).viewPadding.top;
  double get bottomPadding => MediaQuery.of(this).viewPadding.bottom;
  double get leftPadding => MediaQuery.of(this).viewPadding.left;
  double get rightPadding => MediaQuery.of(this).viewPadding.right;
}
