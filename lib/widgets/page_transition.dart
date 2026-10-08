import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

/// Fade + gentle upward slide, used for all in-app navigation.
Route<T> docRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    transitionDuration: DocValues.pageIn,
    reverseTransitionDuration: DocValues.med,
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: DocValues.curveOut,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
