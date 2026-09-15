import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_block.dart';
import 'package:pdoc/markdown/markdown_block_parser.dart';
import 'package:pdoc/markdown/markdown_blockquote.dart';
import 'package:pdoc/markdown/markdown_code_block.dart';
import 'package:pdoc/markdown/markdown_image_block.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/markdown/markdown_link_card.dart';
import 'package:pdoc/markdown/markdown_list_block.dart';
import 'package:pdoc/markdown/markdown_table_block.dart';

class MarkdownView extends StatelessWidget {
  static const double baseFontSize = 18;

  final String source;
  final double bodyFontSize;
  final void Function(String href)? onLinkTap;

  const MarkdownView({
    super.key,
    required this.source,
    this.bodyFontSize = baseFontSize,
    this.onLinkTap,
  });

  Widget _buildBlock(BuildContext context, MarkdownBlock block, double scale) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyLarge!.copyWith(fontSize: bodyFontSize);

    switch (block.type) {
      case MarkdownBlockType.h1:
        return MarkdownInlineText(
          spans: block.inlineSpans!,
          baseStyle: textTheme.headlineMedium!.copyWith(
            fontSize: textTheme.headlineMedium!.fontSize! * scale,
          ),
          onLinkTap: onLinkTap,
        );
      case MarkdownBlockType.h2:
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: MarkdownInlineText(
            spans: block.inlineSpans!,
            baseStyle: textTheme.headlineSmall!.copyWith(
              fontSize: textTheme.headlineSmall!.fontSize! * scale,
            ),
            onLinkTap: onLinkTap,
          ),
        );
      case MarkdownBlockType.h3:
        return MarkdownInlineText(
          spans: block.inlineSpans!,
          baseStyle: textTheme.titleMedium!.copyWith(
            fontSize: textTheme.titleMedium!.fontSize! * scale,
          ),
          onLinkTap: onLinkTap,
        );
      case MarkdownBlockType.paragraph:
        return MarkdownInlineText(
          spans: block.inlineSpans!,
          baseStyle: bodyStyle,
          onLinkTap: onLinkTap,
        );
      case MarkdownBlockType.code:
        return MarkdownCodeBlock(
          code: block.text,
          language: block.lang,
          fontSize: 14 * scale,
        );
      case MarkdownBlockType.list:
        return MarkdownListBlock(
          items: block.listItems!,
          ordered: block.ordered,
          startNumber: block.startNumber,
          baseStyle: bodyStyle,
          onLinkTap: onLinkTap,
        );
      case MarkdownBlockType.table:
        return MarkdownTableBlock(
          rows: block.tableRows!,
          onLinkTap: onLinkTap,
          fontSize: 15 * scale,
        );
      case MarkdownBlockType.blockquote:
        return MarkdownBlockQuote(
          text: block.text,
          onLinkTap: onLinkTap,
          fontSize: bodyFontSize,
        );
      case MarkdownBlockType.rule:
        return Divider(
          color: Theme.of(context).colorScheme.outlineVariant,
          thickness: 1,
          height: 1,
        );
      case MarkdownBlockType.image:
        return MarkdownImageBlock(alt: block.text, src: block.lang ?? '');
      case MarkdownBlockType.linkCard:
        return MarkdownLinkCard(
          heading: block.text,
          bodySpans: block.inlineSpans!,
          onTap: () => onLinkTap?.call(block.lang ?? ''),
          headingFontSize: 17 * scale,
          bodyFontSize: 15 * scale,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocks = MarkdownBlockParser.parse(source);
    final scale = bodyFontSize / baseFontSize;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in blocks) ...[
          _buildBlock(context, block, scale),
          SizedBox(height: block.spacingAfter),
        ],
      ],
    );
  }
}
