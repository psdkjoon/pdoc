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
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Color _tokenColor(SyntaxTokenType type, ColorScheme scheme) {
    switch (type) {
      case SyntaxTokenType.keyword:
        return scheme.primary;
      case SyntaxTokenType.string:
        return scheme.secondary;
      case SyntaxTokenType.comment:
        return scheme.outline;
      case SyntaxTokenType.number:
        return scheme.tertiary;
      case SyntaxTokenType.type:
      case SyntaxTokenType.punctuation:
      case SyntaxTokenType.plain:
        return scheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = SyntaxHighlighter.highlight(widget.code, widget.language);
    final baseStyle = TextStyle(
      fontFamily: DocColors.mono,
      fontSize: widget.fontSize,
      height: 1.5,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        border: Border.all(color: scheme.outlineVariant, width: 2),
        borderRadius: BorderRadius.circular(DocColors.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DocColors.s3,
              vertical: DocColors.s2,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: scheme.outlineVariant, width: 2)),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (widget.language?.isNotEmpty ?? false)
                        ? widget.language!
                        : 'text',
                    style: TextStyle(
                      fontFamily: DocColors.mono,
                      fontSize: (widget.fontSize / 0.8),
                      color: scheme.outline,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: _copyCode,
                    tooltip: _copied ? 'Copied' : 'Copy code',
                    constraints: const BoxConstraints(
                      minWidth: DocColors.s6,
                      minHeight: DocColors.s6,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DocColors.sm),
                      ),
                    ),
                    icon: Icon(
                      _copied ? Icons.check : Icons.copy_rounded,
                      size: (widget.fontSize / 0.8),
                      color: _copied ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DocColors.s3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    for (final token in tokens)
                      TextSpan(
                        text: token.text,
                        style: baseStyle.copyWith(
                          color: _tokenColor(token.type, scheme),
                        ),
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
