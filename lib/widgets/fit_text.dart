import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

class FitText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final double minFontSize;

  final bool reserveSpace;

  const FitText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.minFontSize = DocValues.fsFloor,
    this.reserveSpace = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.merge(style);
    final direction = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final semantics = text;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final fits = _resolveSize(
          base: base,
          direction: direction,
          scaler: scaler,
          available: available,
        );

        if (fits == null) {
          return reserveSpace
              ? SizedBox(
                  height: _lineHeight(base, base.fontSize ?? minFontSize),
                )
              : const SizedBox.shrink();
        }

        return Semantics(
          label: semantics,
          excludeSemantics: true,
          child: Text(
            text,
            maxLines: DocValues.maxLinesOne,
            softWrap: false,
            overflow: TextOverflow.visible,
            textAlign: textAlign,
            textScaler: TextScaler.noScaling,
            style: base.copyWith(fontSize: fits),
          ),
        );
      },
    );
  }

  double _lineHeight(TextStyle base, double size) =>
      size * (base.height ?? DocValues.lhTight);

  double? _resolveSize({
    required TextStyle base,
    required TextDirection direction,
    required TextScaler scaler,
    required double available,
  }) {
    if (!available.isFinite) return base.fontSize;
    final requested = scaler.scale(base.fontSize ?? DocValues.fsBody);
    final floor = minFontSize < DocValues.fsFloor
        ? DocValues.fsFloor
        : minFontSize;
    if (requested <= floor) {
      return _measure(text, base, requested, direction) <= available
          ? requested
          : null;
    }

    final step = (requested - floor) / DocValues.fitSteps;
    for (var i = 0; i <= DocValues.fitSteps; i++) {
      final size = requested - step * i;
      if (_measure(text, base, size, direction) <= available) return size;
    }
    return null;
  }

  static double _measure(
    String text,
    TextStyle base,
    double size,
    TextDirection direction,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: base.copyWith(fontSize: size),
      ),
      textDirection: direction,
      maxLines: DocValues.maxLinesOne,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}

class WrapText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  const WrapText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.merge(style);
    final direction = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final label = Text(
          text,
          textAlign: textAlign,
          style: base,
          maxLines: maxLines,
          softWrap: true,
          overflow: maxLines == null
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        );

        final available = constraints.maxWidth;
        if (!available.isFinite || maxLines != null) return label;

        final size = scaler.scale(base.fontSize ?? DocValues.fsBody);
        var widest = DocValues.s0;
        for (final word in text.split(RegExp(r'\s+'))) {
          if (word.isEmpty) continue;
          final width = FitText._measure(word, base, size, direction);
          if (width > widest) widest = width;
        }
        if (widest <= available) return label;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: widest),
            child: label,
          ),
        );
      },
    );
  }
}
