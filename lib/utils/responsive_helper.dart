import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getResponsiveFontSize(BuildContext context, double size) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Base width is 375 (iPhone SE/standard mobile)
    return size * (screenWidth / 375);
  }

  static double getResponsiveHeight(BuildContext context, double height) {
    double screenHeight = MediaQuery.of(context).size.height;
    // Base height is 812
    return height * (screenHeight / 812);
  }

  static double getResponsiveWidth(BuildContext context, double width) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Base width is 375
    return width * (screenWidth / 375);
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1024) return 4; // Desktop
    if (width >= 600) return 3;  // Tablet
    return 2; // Mobile
  }

  static double getGridChildAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 0.8;
    if (isTablet(context)) return 0.75;
    return 0.75;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 100, vertical: 20);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 16);
    }
    return const EdgeInsets.all(16);
  }

  static double getCardElevation(BuildContext context) {
    return isDesktop(context) ? 8 : 4;
  }

  static double getMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity;
  }
}


