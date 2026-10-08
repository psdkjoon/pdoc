import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdoc/markdown/syntax_highlighter.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownCodeBlock extends StatefulWidget {
  final String code;
  final String? language;
  final double fontSize;

  const MarkdownCodeBlock({
    super.key,
    required this.code,
    required this.language,
    required this.fontSize,
  });

  @override
  State<MarkdownCodeBlock> createState() => _MarkdownCodeBlockState();
}

class _MarkdownCodeBlockState extends State<MarkdownCodeBlock> {
  bool _copied = false;
  bool _hovered = false;

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(DocValues.toast);
    if (mounted) setState(() => _copied = false);
  }

  TextStyle _tokenStyle(
    SyntaxTokenType type,
    SyntaxColors colors,
    TextStyle base,
  ) {
    switch (type) {
      case SyntaxTokenType.keyword:
        return base.copyWith(
          color: colors.keyword,
          fontWeight: DocValues.fwBold,
        );
      case SyntaxTokenType.string:
        return base.copyWith(color: colors.string);
      case SyntaxTokenType.escape:
        return base.copyWith(
          color: colors.escape,
          fontWeight: DocValues.fwBold,
        );
      case SyntaxTokenType.interpolation:
        return base.copyWith(
          color: colors.interpolation,
          backgroundColor: colors.interpolation.withValues(
            alpha: DocValues.alphaFocus,
          ),
        );
      case SyntaxTokenType.comment:
        return base.copyWith(
          color: colors.comment,
          fontStyle: FontStyle.italic,
        );
      case SyntaxTokenType.docComment:
        return base.copyWith(
          color: colors.docComment,
          fontStyle: FontStyle.italic,
        );
      case SyntaxTokenType.number:
        return base.copyWith(color: colors.number);
      case SyntaxTokenType.constant:
        return base.copyWith(
          color: colors.constant,
          fontWeight: DocValues.fwMedium,
        );
      case SyntaxTokenType.type:
        return base.copyWith(
          color: colors.type,
          fontWeight: DocValues.fwMedium,
        );
      case SyntaxTokenType.function:
        return base.copyWith(
          color: colors.function,
          fontWeight: DocValues.fwMedium,
        );
      case SyntaxTokenType.annotation:
        return base.copyWith(
          color: colors.annotation,
          fontStyle: FontStyle.italic,
        );
      case SyntaxTokenType.property:
        return base.copyWith(color: colors.property);
      case SyntaxTokenType.variable:
        return base.copyWith(color: colors.variable);
      case SyntaxTokenType.flag:
        return base.copyWith(color: colors.flag);
      case SyntaxTokenType.operator:
        return base.copyWith(color: colors.op);
      case SyntaxTokenType.punctuation:
        return base.copyWith(color: colors.punctuation);
      case SyntaxTokenType.plain:
        return base.copyWith(color: colors.plain);
    }
  }

  Widget _copyButton(ColorScheme scheme, double labelSize) {
    final color = _copied ? scheme.primary : scheme.onSurfaceVariant;
    return Semantics(
      button: true,
      label: _copied ? 'Copied' : 'Copy code',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _copyCode,
          child: AnimatedContainer(
            duration: DocValues.hover,
            curve: DocValues.curveHover,
            padding: const EdgeInsets.symmetric(
              horizontal: DocValues.s28,
              vertical: DocValues.s15,
            ),
            decoration: BoxDecoration(
              color: _copied
                  ? scheme.primary.withValues(alpha: DocValues.alphaFocus * 2)
                  : DocValues.transparent,
              borderRadius: BorderRadius.circular(DocValues.pill),
              border: Border.all(
                color: _copied ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: AnimatedSwitcher(
              duration: DocValues.fast,
              switchInCurve: DocValues.curveSpring,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: Row(
                key: ValueKey<bool>(_copied),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: labelSize,
                    color: color,
                  ),
                  const SizedBox(width: DocValues.s1),
                  Text(
                    _copied ? 'Copied' : 'Copy',
                    style: TextStyle(
                      fontFamily: DocValues.mono,
                      fontSize: labelSize * 0.9,
                      fontWeight: DocValues.fwMedium,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.syntax;
    final palette = context.docColors;
    final tokens = SyntaxHighlighter.highlight(widget.code, widget.language);
    final baseStyle = TextStyle(
      fontFamily: DocValues.mono,
      fontSize: widget.fontSize,
      height: DocValues.lhCode,
      color: colors.plain,
    );
    final labelSize = widget.fontSize / DocValues.codeLabelRatio * 0.85;
    final language = (widget.language?.isNotEmpty ?? false)
        ? widget.language!
        : 'text';
    final radius = BorderRadius.circular(DocValues.rCode);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: DocValues.hover,
        curve: DocValues.curveHover,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: palette.codeBg,
          borderRadius: radius,
          border: Border.all(
            color: _hovered
                ? scheme.primary.withValues(alpha: 0.45)
                : palette.codeBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: DocValues.shadowColor.withValues(
                alpha: _hovered ? 0.22 : 0.10,
              ),
              blurRadius: _hovered ? 28 : 18,
              offset: const Offset(DocValues.s0, DocValues.s1 + DocValues.s1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                DocValues.s35,
                DocValues.s2,
                DocValues.s28,
                DocValues.s2,
              ),
              decoration: BoxDecoration(
                color: scheme.onSurface.withValues(alpha: 0.035),
                border: Border(bottom: BorderSide(color: palette.codeBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    width: DocValues.s2,
                    height: DocValues.s2,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: DocValues.s25),
                  Expanded(
                    child: Text(
                      language,
                      maxLines: DocValues.maxLinesOne,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: DocValues.mono,
                        fontSize: labelSize,
                        fontWeight: DocValues.fwMedium,
                        color: scheme.onSurfaceVariant,
                        letterSpacing: DocValues.lsMono,
                      ),
                    ),
                  ),
                  _copyButton(scheme, labelSize),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DocValues.s35,
                vertical: DocValues.s35,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      for (final token in tokens)
                        TextSpan(
                          text: token.text,
                          style: _tokenStyle(token.type, colors, baseStyle),
                        ),
                    ],
                  ),
                  style: baseStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
