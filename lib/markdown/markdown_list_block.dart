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

  static const _bulletGlyphs = ['•', '◦', '▪'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fontSize = baseStyle.fontSize ?? DocValues.fsBody;
    final markerStyle = baseStyle.copyWith(
      color: scheme.primary,
      fontWeight: DocValues.fwSemi,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: EdgeInsets.only(
              left: item.depth * DocValues.s4,
              bottom: DocValues.s2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: fontSize * DocValues.listMarkerEm,
                  ),
                  child: Text(
                    item.ordered
                        ? '${item.number}.'
                        : _bulletGlyphs[item.depth % _bulletGlyphs.length],
                    textAlign: TextAlign.end,
                    softWrap: false,
                    style: markerStyle,
                  ),
                ),
                const SizedBox(width: DocValues.s2),
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
