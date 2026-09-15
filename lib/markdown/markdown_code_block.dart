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
    this.fontSize = 14,
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

  Color _tokenColor(
    SyntaxTokenType type,
    ColorScheme scheme,
    DocSurfaces docSurfaces,
  ) {
    switch (type) {
      case SyntaxTokenType.keyword:
        return scheme.primary;
      case SyntaxTokenType.string:
        return scheme.secondary;
      case SyntaxTokenType.comment:
        return docSurfaces.textFaint;
      case SyntaxTokenType.number:
        return scheme.tertiary;
      case SyntaxTokenType.type:
        return docSurfaces.heading;
      case SyntaxTokenType.punctuation:
      case SyntaxTokenType.plain:
        return scheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final docSurfaces = context.docSurfaces;
    final tokens = SyntaxHighlighter.highlight(widget.code, widget.language);
    final baseStyle = TextStyle(
      fontFamily: DocColors.mono,
      fontSize: widget.fontSize,
      height: 1.5,
    );

    return Container(
      decoration: BoxDecoration(
        color: docSurfaces.codeBg,
        border: Border.all(color: docSurfaces.codeBorder),
        borderRadius: BorderRadius.circular(DocColors.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: docSurfaces.codeBorder)),
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
                      fontSize: 11,
                      color: docSurfaces.textFaint,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(DocColors.sm),
                    onTap: _copyCode,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        _copied ? Icons.check : Icons.copy_rounded,
                        size: 16,
                        color: _copied
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    for (final token in tokens)
                      TextSpan(
                        text: token.text,
                        style: baseStyle.copyWith(
                          color: _tokenColor(token.type, scheme, docSurfaces),
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
