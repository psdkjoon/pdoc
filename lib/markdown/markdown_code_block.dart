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

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(DocValues.toast);
    if (mounted) setState(() => _copied = false);
  }

  TextStyle _tokenStyle(
    SyntaxTokenType type,
    ColorScheme scheme,
    TextStyle base,
  ) {
    switch (type) {
      case SyntaxTokenType.keyword:
        return base.copyWith(
          color: scheme.primary,
          fontWeight: DocValues.fwBold,
        );
      case SyntaxTokenType.string:
        return base.copyWith(color: scheme.secondary);
      case SyntaxTokenType.escape:
        return base.copyWith(
          color: scheme.tertiary,
          fontWeight: DocValues.fwBold,
        );
      case SyntaxTokenType.interpolation:
        return base.copyWith(
          color: scheme.tertiary,
          backgroundColor: scheme.tertiary.withValues(
            alpha: DocValues.alphaFocus,
          ),
        );
      case SyntaxTokenType.comment:
        return base.copyWith(
          color: scheme.outline,
          fontStyle: FontStyle.italic,
        );
      case SyntaxTokenType.docComment:
        return base.copyWith(
          color: scheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        );
      case SyntaxTokenType.number:
      case SyntaxTokenType.constant:
        return base.copyWith(color: scheme.tertiary);
      case SyntaxTokenType.type:
        return base.copyWith(
          color: scheme.primaryContainer,
          fontWeight: DocValues.fwMedium,
        );
      case SyntaxTokenType.function:
        return base.copyWith(
          color: scheme.onSurface,
          fontWeight: DocValues.fwBold,
        );
      case SyntaxTokenType.annotation:
        return base.copyWith(
          color: scheme.secondary,
          fontStyle: FontStyle.italic,
        );
      case SyntaxTokenType.property:
        return base.copyWith(color: scheme.primary);
      case SyntaxTokenType.variable:
        return base.copyWith(color: scheme.tertiary);
      case SyntaxTokenType.flag:
        return base.copyWith(color: scheme.secondary);
      case SyntaxTokenType.operator:
      case SyntaxTokenType.punctuation:
        return base.copyWith(color: scheme.onSurfaceVariant);
      case SyntaxTokenType.plain:
        return base.copyWith(color: scheme.onSurface);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = SyntaxHighlighter.highlight(widget.code, widget.language);
    final baseStyle = TextStyle(
      fontFamily: DocValues.mono,
      fontSize: widget.fontSize,
      height: DocValues.lhCode,
    );
    final labelSize = widget.fontSize / DocValues.codeLabelRatio;
    final language = (widget.language?.isNotEmpty ?? false)
        ? widget.language!
        : 'text';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        border: Border.all(
          color: scheme.outlineVariant,
          width: DocValues.borderMed,
        ),
        borderRadius: BorderRadius.circular(DocValues.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: DocValues.s3,
              vertical: DocValues.s2,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: scheme.outlineVariant,
                  width: DocValues.borderMed,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    language,
                    maxLines: DocValues.maxLinesOne,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: DocValues.mono,
                      fontSize: labelSize,
                      color: scheme.outline,
                      letterSpacing: DocValues.lsMono,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _copyCode,
                  tooltip: _copied ? 'Copied' : 'Copy code',
                  constraints: const BoxConstraints(
                    minWidth: DocValues.s6,
                    minHeight: DocValues.s6,
                  ),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DocValues.sm),
                    ),
                  ),
                  icon: Icon(
                    _copied ? Icons.check : Icons.copy_rounded,
                    size: labelSize,
                    color: _copied ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DocValues.s3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    for (final token in tokens)
                      TextSpan(
                        text: token.text,
                        style: _tokenStyle(token.type, scheme, baseStyle),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
