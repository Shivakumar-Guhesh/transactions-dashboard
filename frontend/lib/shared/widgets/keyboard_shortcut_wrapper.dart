import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_animations.dart';

class KeyboardScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    Widget scrollbar = super.buildScrollbar(context, child, details);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
            _scroll(details, 100), // Increased slightly for better feel
        const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
            _scroll(details, -100),
        const SingleActivator(LogicalKeyboardKey.pageDown): () =>
            _scroll(details, 500),
        const SingleActivator(LogicalKeyboardKey.pageUp): () =>
            _scroll(details, -500),
      },
      child: Focus(
        autofocus: true, // Automatically grabs focus when the widget appears
        descendantsAreFocusable: true,
        child: scrollbar,
      ),
    );
  }

  void _scroll(ScrollableDetails details, double offset) {
    final controller = details.controller;
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        (controller.offset + offset).clamp(
          0,
          controller.position.maxScrollExtent,
        ),
        duration: AppAnimations.durationFast,
        curve: Curves
            .easeOut, // Linear feels "laggy" with keys; easeOut is snappier
      );
    }
  }
}
