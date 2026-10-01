import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdoc/src/theme.dart';

class _Particle {
  _Particle({required this.position, required this.velocity});

  Offset position;
  Offset velocity;
}

class Background extends StatefulWidget {
  const Background({
    super.key,
    required this.accent,
    required this.backgroundColor,
    this.particleCount = DocValues.particlesHomeMedium,
    this.maxSpeed = DocValues.particleMaxSpeed,
    this.connectionDistance = DocValues.particleLinkDistance,
    this.dotRadius = DocValues.particleDotRadius,
    this.lineWidth = DocValues.particleLineWidth,
    this.reducedMotion,
  });

  final Color accent;
  final Color backgroundColor;
  final int particleCount;
  final double maxSpeed;
  final double connectionDistance;
  final double dotRadius;
  final double lineWidth;
  final bool? reducedMotion;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  final List<_Particle> _particles = [];
  final Random _random = Random();
  final _Repaint _repaint = _Repaint();

  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  bool get _isReduced =>
      widget.reducedMotion ?? MediaQuery.disableAnimationsOf(context);

  void _ensureParticles(Size size) {
    final sameCount = _particles.length == widget.particleCount;
    if (size == _lastSize && sameCount) return;
    _lastSize = size;
    _particles.clear();

    for (var i = 0; i < widget.particleCount; i++) {
      final angle = _random.nextDouble() * pi * DocValues.doubleRadiusFactor;
      final speed = _random.nextDouble() * widget.maxSpeed;
      _particles.add(
        _Particle(
          position: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          velocity: Offset(cos(angle), sin(angle)) * speed,
        ),
      );
    }
  }

  void _onTick(Duration elapsed) {
    final dt = (_lastElapsed == Duration.zero)
        ? DocValues.s0
        : (elapsed - _lastElapsed).inMicroseconds / DocValues.microsPerSecond;
    _lastElapsed = elapsed;
    if (dt <= DocValues.s0 || dt > DocValues.particleMaxDelta) return;

    final size = _lastSize;
    if (size == Size.zero) return;

    for (final p in _particles) {
      p.position += p.velocity * dt;

      if (p.position.dx <= DocValues.s0 || p.position.dx >= size.width) {
        p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
        p.position = Offset(
          p.position.dx.clamp(DocValues.s0, size.width).toDouble(),
          p.position.dy,
        );
      }
      if (p.position.dy <= DocValues.s0 || p.position.dy >= size.height) {
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
        p.position = Offset(
          p.position.dx,
          p.position.dy.clamp(DocValues.s0, size.height).toDouble(),
        );
      }
    }

    _repaint.notify();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isReduced) {
      _ticker?.stop();
      _lastElapsed = Duration.zero;
    } else if (_ticker?.isActive != true) {
      _ticker?.start();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _repaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            _ensureParticles(size);

            return RepaintBoundary(
              child: CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  repaint: _repaint,
                  particles: _particles,
                  accent: widget.accent,
                  backgroundColor: widget.backgroundColor,
                  connectionDistance: widget.connectionDistance,
                  dotRadius: widget.dotRadius,
                  lineWidth: widget.lineWidth,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Repaint extends ChangeNotifier {
  void notify() => notifyListeners();
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required Listenable repaint,
    required this.particles,
    required this.accent,
    required this.backgroundColor,
    required this.connectionDistance,
    required this.dotRadius,
    required this.lineWidth,
  }) : super(repaint: repaint);

  final List<_Particle> particles;
  final Color accent;
  final Color backgroundColor;
  final double connectionDistance;
  final double dotRadius;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);

    final dotPaint = Paint()..color = accent;
    final linePaint = Paint()..strokeWidth = lineWidth;

    for (var i = 0; i < particles.length; i++) {
      final a = particles[i];
      for (var j = i + 1; j < particles.length; j++) {
        final b = particles[j];
        final dist = (a.position - b.position).distance;
        if (dist < connectionDistance) {
          final opacity =
              (DocValues.scaleUnit - dist / connectionDistance) *
              DocValues.alphaLineMax;
          linePaint.color = accent.withValues(
            alpha: opacity
                .clamp(DocValues.alphaZero, DocValues.alphaLineMax)
                .toDouble(),
          );
          canvas.drawLine(a.position, b.position, linePaint);
        }
      }
    }
    for (final p in particles) {
      canvas.drawCircle(p.position, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.accent != accent ||
      old.backgroundColor != backgroundColor ||
      old.connectionDistance != connectionDistance ||
      old.dotRadius != dotRadius ||
      old.lineWidth != lineWidth;
}
