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
    required this.fontSize,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DocValues.s3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(DocValues.lg),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: DocValues.s3),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: scheme.primary, width: DocValues.quoteBar),
          ),
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
      ),
    );
  }
}
