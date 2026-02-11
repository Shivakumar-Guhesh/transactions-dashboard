import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth {
    return MediaQuery.sizeOf(this).width;
  }

  double get screenHeight {
    return MediaQuery.sizeOf(this).height;
  }

  bool get isMobile {
    return screenWidth < AppSizes.mobileBreakpoint;
  }

  bool get isTablet {
    return screenWidth >= AppSizes.mobileBreakpoint &&
        screenWidth <= AppSizes.tabletBreakpoint;
  }

  bool get isDesktop {
    return screenWidth > AppSizes.tabletBreakpoint;
  }

  T responsiveValue<T>({required T mobile, T? tablet, required T desktop}) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet ?? desktop;
    return mobile;
  }
}
