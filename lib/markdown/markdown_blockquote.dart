import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_inline.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownBlockQuote extends StatelessWidget {
  final String text;
  final double fontSize;
  final void Function(String href)? onLinkTap;

  const MarkdownBlockQuote({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border(left: BorderSide(color: scheme.primary, width: 3)),
        borderRadius: BorderRadius.circular(DocColors.sm),
      ),
      child: MarkdownInlineText(
        spans: MarkdownInlineParser.parse(text),
        baseStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: fontSize,
          fontStyle: FontStyle.italic,
          color: scheme.onSurfaceVariant,
        ),
        onLinkTap: onLinkTap,
      ),
    );
  }
}
