import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_block.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownListBlock extends StatelessWidget {
  final List<MarkdownListItem> items;
  final TextStyle baseStyle;
  final void Function(String href)? onLinkTap;

  const MarkdownListBlock({
    super.key,
    required this.items,
    required this.baseStyle,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fontSize = baseStyle.fontSize ?? DocValues.fsBody;
    final lineHeight = fontSize * (baseStyle.height ?? DocValues.lhBody);
    final markerStyle = baseStyle.copyWith(
      color: scheme.primary,
      fontWeight: DocValues.fwBold,
      fontSize: fontSize * 0.85,
      fontFamily: DocValues.mono,
      height: 1,
    );

    Widget marker(MarkdownListItem item) {
      if (item.ordered) {
        return Container(
          constraints: BoxConstraints(minWidth: fontSize * 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: DocValues.s15,
            vertical: DocValues.s1 / 2,
          ),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(DocValues.pill),
          ),
          child: Text(
            '${item.number}',
            textAlign: TextAlign.center,
            softWrap: false,
            style: markerStyle,
          ),
        );
      }
      final size = fontSize * (item.depth == 0 ? 0.36 : 0.3);
      final filled = item.depth % 2 == 0;
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? scheme.primary : DocValues.transparent,
          border: filled
              ? null
              : Border.all(color: scheme.primary, width: DocValues.borderMed),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: EdgeInsets.only(
              left: item.depth * DocValues.s4,
              bottom: DocValues.s28,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: fontSize * 1.7,
                  height: lineHeight,
                  child: Align(
                    alignment: item.ordered
                        ? Alignment.centerLeft
                        : const Alignment(-0.2, 0),
                    child: marker(item),
                  ),
                ),
                const SizedBox(width: DocValues.s1),
                Expanded(
                  child: MarkdownInlineText(
                    spans: item.inlineSpans,
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
