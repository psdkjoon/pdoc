import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_inline.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownListBlock extends StatelessWidget {
  final List<String> items;
  final bool ordered;
  final int startNumber;
  final TextStyle baseStyle;
  final void Function(String href)? onLinkTap;

  const MarkdownListBlock({
    super.key,
    required this.items,
    required this.ordered,
    required this.baseStyle,
    this.startNumber = 1,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final markerWidth = (baseStyle.fontSize ?? 15) * 1.6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: DocColors.s2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: markerWidth,
                  child: Text(
                    ordered ? '${startNumber + index}.' : '•',
                    textAlign: TextAlign.end,
                    style: baseStyle.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: DocColors.s2),
                Expanded(
                  child: MarkdownInlineText(
                    spans: MarkdownInlineParser.parse(items[index]),
                    baseStyle: baseStyle,
                    onLinkTap: onLinkTap,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
