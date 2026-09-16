import 'package:pdoc/markdown/markdown_inline.dart';

enum MarkdownBlockType {
  h1,
  h2,
  h3,
  paragraph,
  code,
  list,
  table,
  blockquote,
  rule,
  image,
  linkCard,
}

class MarkdownBlock {
  final MarkdownBlockType type;
  final String text;
  final String? lang;
  final List<String>? listItems;
  final bool ordered;
  final int startNumber;
  final List<List<String>>? tableRows;
  final List<MarkdownInlineSpan>? inlineSpans;
  final List<MarkdownInlineSpan>? headingSpans;
  final double spacingAfter;

  MarkdownBlock._({
    required this.type,
    this.text = '',
    this.lang,
    this.listItems,
    this.ordered = false,
    this.startNumber = 1,
    this.tableRows,
    this.inlineSpans,
    this.headingSpans,
    this.spacingAfter = 24,
  });

  factory MarkdownBlock.heading(MarkdownBlockType type, String text) =>
      MarkdownBlock._(
        type: type,
        text: text,
        inlineSpans: MarkdownInlineParser.parse(text),
        spacingAfter: 16,
      );

  factory MarkdownBlock.paragraph(String text) => MarkdownBlock._(
    type: MarkdownBlockType.paragraph,
    text: text,
    inlineSpans: MarkdownInlineParser.parse(text),
  );

  factory MarkdownBlock.code(String text, String? lang) =>
      MarkdownBlock._(type: MarkdownBlockType.code, text: text, lang: lang);

  factory MarkdownBlock.list(
    List<String> items,
    bool ordered,
    int startNumber,
  ) => MarkdownBlock._(
    type: MarkdownBlockType.list,
    listItems: items,
    ordered: ordered,
    startNumber: startNumber,
  );

  factory MarkdownBlock.table(List<List<String>> rows) =>
      MarkdownBlock._(type: MarkdownBlockType.table, tableRows: rows);

  factory MarkdownBlock.blockquote(String text) =>
      MarkdownBlock._(type: MarkdownBlockType.blockquote, text: text);

  factory MarkdownBlock.rule() =>
      MarkdownBlock._(type: MarkdownBlockType.rule, spacingAfter: 16);

  factory MarkdownBlock.image(String alt, String src) =>
      MarkdownBlock._(type: MarkdownBlockType.image, text: alt, lang: src);

  factory MarkdownBlock.linkCard(String heading, String body, String href) =>
      MarkdownBlock._(
        type: MarkdownBlockType.linkCard,
        text: heading,
        lang: href,
        inlineSpans: MarkdownInlineParser.parse(body),
        headingSpans: MarkdownInlineParser.parse(heading),
      );
}
