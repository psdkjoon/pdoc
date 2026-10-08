import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

/// Fades and slides its child in once, optionally after [delay].
///
/// Give it a new [key] to replay the animation (e.g. when the page changes).
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double dy;
  final double dx;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = DocValues.reveal,
    this.dy = 14,
    this.dx = 0,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curved = CurvedAnimation(
    parent: _controller,
    curve: DocValues.curveOut,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return AnimatedBuilder(
      animation: _curved,
      child: widget.child,
      builder: (context, child) {
        final t = _curved.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((1 - t) * widget.dx, (1 - t) * widget.dy),
            child: child,
          ),
        );
      },
    );
  }
}

/// Delay for the n-th item of a staggered list, capped so long lists
/// don't take forever to finish.
Duration staggerDelay(int index, {int maxSteps = 10}) {
  final steps = index < maxSteps ? index : maxSteps;
  return DocValues.stagger * steps;
}
