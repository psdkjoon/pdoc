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
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/reveal.dart';

class MarkdownView extends StatelessWidget {
  static const double baseFontSize = DocValues.readerBase;

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
          padding: const EdgeInsets.only(top: DocValues.s28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownInlineText(
                spans: block.inlineSpans!,
                baseStyle: textTheme.headlineSmall!.copyWith(
                  fontSize: textTheme.headlineSmall!.fontSize! * scale,
                ),
                onLinkTap: onLinkTap,
              ),
              const SizedBox(height: DocValues.s25),
              Container(
                width: DocValues.s6,
                height: DocValues.sPx3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(DocValues.pill),
                ),
              ),
            ],
          ),
        );
      case MarkdownBlockType.h3:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: DocValues.fsTitleSm * scale * 0.38,
                right: DocValues.s25,
              ),
              child: Container(
                width: DocValues.s1,
                height: DocValues.fsTitleSm * scale * 0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(DocValues.pill),
                ),
              ),
            ),
            Expanded(
              child: MarkdownInlineText(
                spans: block.inlineSpans!,
                baseStyle: textTheme.titleMedium!.copyWith(
                  fontSize: textTheme.titleMedium!.fontSize! * scale,
                ),
                onLinkTap: onLinkTap,
              ),
            ),
          ],
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
          fontSize: DocValues.fsBody2 * scale,
        );
      case MarkdownBlockType.list:
        return MarkdownListBlock(
          items: block.listItems!,
          baseStyle: bodyStyle,
          onLinkTap: onLinkTap,
        );
      case MarkdownBlockType.table:
        return MarkdownTableBlock(
          rows: block.tableRows!,
          onLinkTap: onLinkTap,
          fontSize: DocValues.fsBody * scale,
        );
      case MarkdownBlockType.blockquote:
        return MarkdownBlockQuote(
          text: block.text,
          onLinkTap: onLinkTap,
          fontSize: bodyFontSize,
        );
      case MarkdownBlockType.rule:
        final primary = Theme.of(context).colorScheme.primary;
        return Container(
          height: DocValues.sPx2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DocValues.pill),
            gradient: LinearGradient(
              colors: [
                primary.withValues(alpha: 0.0),
                primary.withValues(alpha: 0.55),
                primary.withValues(alpha: 0.0),
              ],
            ),
          ),
        );
      case MarkdownBlockType.image:
        return MarkdownImageBlock(alt: block.text, src: block.lang ?? '');
      case MarkdownBlockType.linkCard:
        return MarkdownLinkCard(
          headingSpans: block.headingSpans!,
          bodySpans: block.inlineSpans!,
          onTap: () => onLinkTap?.call(block.lang ?? ''),
          headingFontSize: DocValues.fsTitleSm * scale,
          bodyFontSize: DocValues.fsBody * scale,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocks = MarkdownBlockParser.parse(source);
    final scale = bodyFontSize / baseFontSize;
    final pageKey = source.hashCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          Reveal(
            key: ValueKey<String>('$pageKey-$i'),
            delay: staggerDelay(i),
            child: _buildBlock(context, blocks[i], scale),
          ),
          SizedBox(height: blocks[i].spacingAfter),
        ],
      ],
    );
  }
}
