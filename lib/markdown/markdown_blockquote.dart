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
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(DocColors.s3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(DocColors.lg),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: DocColors.s3),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: scheme.primary, width: 3)),
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
