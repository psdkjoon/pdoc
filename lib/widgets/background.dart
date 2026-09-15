import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    this.particleCount = 70,
    this.maxSpeed = 12.0,
    this.connectionDistance = 120.0,
    this.dotRadius = 1.6,
    this.lineWidth = 0.6,
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

  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  bool get _isReduced =>
      widget.reducedMotion ?? MediaQuery.of(context).disableAnimations;

  void _ensureParticles(Size size) {
    if (size == _lastSize && _particles.isNotEmpty) return;
    _lastSize = size;
    _particles.clear();

    for (int i = 0; i < widget.particleCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
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
    if (_isReduced) return;

    final dt = (_lastElapsed == Duration.zero)
        ? 0.0
        : (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0 || dt > 0.25) return;

    final size = _lastSize;
    if (size == Size.zero) return;

    for (final p in _particles) {
      p.position += p.velocity * dt;

      if (p.position.dx <= 0 || p.position.dx >= size.width) {
        p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
        p.position = Offset(
          p.position.dx.clamp(0, size.width).toDouble(),
          p.position.dy,
        );
      }
      if (p.position.dy <= 0 || p.position.dy >= size.height) {
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
        p.position = Offset(
          p.position.dx,
          p.position.dy.clamp(0, size.height).toDouble(),
        );
      }
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isReduced) {
      if (_ticker?.isActive != true) _ticker?.start();
    } else {
      _ticker?.stop();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _ensureParticles(size);

        return RepaintBoundary(
          child: CustomPaint(
            size: size,
            painter: _ParticlePainter(
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
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.accent,
    required this.backgroundColor,
    required this.connectionDistance,
    required this.dotRadius,
    required this.lineWidth,
  });

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

    for (int i = 0; i < particles.length; i++) {
      final a = particles[i];
      for (int j = i + 1; j < particles.length; j++) {
        final b = particles[j];
        final dist = (a.position - b.position).distance;
        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance) * 0.5;
          linePaint.color = accent.withValues(
            alpha: opacity.clamp(0.0, 0.5).toDouble(),
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
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
