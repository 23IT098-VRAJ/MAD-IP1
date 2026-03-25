import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double tabletBreakpoint = 600;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static EdgeInsets safePadding(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  static double rWidth(BuildContext context, double fraction) {
    return screenWidth(context) * fraction;
  }

  static double rHeight(BuildContext context, double fraction) {
    return screenHeight(context) * fraction;
  }

  static double rFont(BuildContext context, double base) {
    final double scale = isTablet(context) ? 1.2 : 1;
    return base * scale;
  }
}
