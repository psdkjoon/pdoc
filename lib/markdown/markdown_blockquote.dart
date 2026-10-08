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
    final radius = BorderRadius.circular(DocValues.rCode);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            scheme.primary.withValues(alpha: 0.14),
            scheme.primary.withValues(alpha: 0.03),
          ],
        ),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: DocValues.sPx3 + 1, color: scheme.primary),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DocValues.s4,
                  vertical: DocValues.s35,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: DocValues.s1,
                        right: DocValues.s28,
                      ),
                      child: Icon(
                        Icons.format_quote_rounded,
                        size: fontSize * 1.3,
                        color: scheme.primary.withValues(alpha: 0.8),
                      ),
                    ),
                    Expanded(
                      child: MarkdownInlineText(
                        spans: MarkdownInlineParser.parse(text),
                        baseStyle: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(
                              fontSize: fontSize,
                              fontStyle: FontStyle.italic,
                              color: scheme.onSurface.withValues(alpha: 0.85),
                            ),
                        onLinkTap: onLinkTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
