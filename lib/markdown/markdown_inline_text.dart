import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_inline.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownInlineText extends StatefulWidget {
  final List<MarkdownInlineSpan> spans;
  final TextStyle baseStyle;
  final TextAlign textAlign;
  final void Function(String href)? onLinkTap;

  const MarkdownInlineText({
    super.key,
    required this.spans,
    required this.baseStyle,
    this.textAlign = TextAlign.start,
    this.onLinkTap,
  });

  @override
  State<MarkdownInlineText> createState() => _MarkdownInlineTextState();
}

class _MarkdownInlineTextState extends State<MarkdownInlineText> {
  List<TapGestureRecognizer> _recognizers = [];

  void _disposeAll(List<TapGestureRecognizer> recognizers) {
    for (final recognizer in recognizers) {
      recognizer.dispose();
    }
  }

  @override
  void dispose() {
    _disposeAll(_recognizers);
    super.dispose();
  }

  TextStyle _withExtraEmphasis(
    TextStyle style,
    MarkdownInlineSpan span, {
    Color? boldColor,
    Color? strikeColor,
  }) {
    var result = style;
    if (span.bold) {
      result = result.copyWith(
        fontWeight: DocValues.fwBold,
        color: boldColor ?? result.color,
      );
    }
    if (span.italic) {
      result = result.copyWith(fontStyle: FontStyle.italic);
    }
    if (span.strike) {
      result = result.copyWith(
        decoration: result.decoration == TextDecoration.underline
            ? TextDecoration.combine([
                TextDecoration.underline,
                TextDecoration.lineThrough,
              ])
            : TextDecoration.lineThrough,
        color: strikeColor ?? result.color,
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseStyle = widget.baseStyle;

    final previous = _recognizers;
    final next = <TapGestureRecognizer>[];
    WidgetsBinding.instance.addPostFrameCallback((_) => _disposeAll(previous));
    _recognizers = next;

    return Text.rich(
      TextSpan(
        children: widget.spans.map((span) {
          switch (span.type) {
            case MarkdownInlineType.text:
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle,
                  span,
                  boldColor: scheme.onSurface,
                  strikeColor: scheme.outline,
                ),
              );
            case MarkdownInlineType.bold:
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle.copyWith(
                    fontWeight: DocValues.fwBold,
                    color: scheme.onSurface,
                  ),
                  span,
                  strikeColor: scheme.outline,
                ),
              );
            case MarkdownInlineType.italic:
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle.copyWith(fontStyle: FontStyle.italic),
                  span,
                  boldColor: scheme.onSurface,
                  strikeColor: scheme.outline,
                ),
              );
            case MarkdownInlineType.boldItalic:
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle.copyWith(
                    fontWeight: DocValues.fwBold,
                    fontStyle: FontStyle.italic,
                    color: scheme.onSurface,
                  ),
                  span,
                  strikeColor: scheme.outline,
                ),
              );
            case MarkdownInlineType.strike:
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: scheme.outline,
                  ),
                  span,
                  boldColor: scheme.onSurface,
                ),
              );
            case MarkdownInlineType.code:
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle.copyWith(
                    fontFamily: DocValues.mono,
                    fontSize: baseStyle.fontSize! * DocValues.codeInlineRatio,
                    color: scheme.primaryContainer,
                    fontWeight: DocValues.fwMedium,
                    backgroundColor: scheme.primary.withValues(alpha: 0.13),
                  ),
                  span,
                ),
              );
            case MarkdownInlineType.link:
              final recognizer = TapGestureRecognizer()
                ..onTap = () => widget.onLinkTap?.call(span.href ?? '');
              next.add(recognizer);
              return TextSpan(
                text: span.text,
                style: _withExtraEmphasis(
                  baseStyle.copyWith(
                    color: scheme.primary,
                    fontWeight: DocValues.fwSemi,
                    decoration: TextDecoration.underline,
                    decorationColor: scheme.primary,
                  ),
                  span,
                ),
                recognizer: recognizer,
              );
          }
        }).toList(),
      ),
      textAlign: widget.textAlign,
    );
  }
}
