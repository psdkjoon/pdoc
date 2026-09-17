enum MarkdownInlineType { text, bold, italic, boldItalic, code, link, strike }

class MarkdownInlineSpan {
  final MarkdownInlineType type;
  final String text;
  final String? href;

  final bool bold;
  final bool italic;
  final bool strike;

  const MarkdownInlineSpan(
    this.type,
    this.text, {
    this.href,
    this.bold = false,
    this.italic = false,
    this.strike = false,
  });

  MarkdownInlineSpan _withExtraEmphasis({
    bool bold = false,
    bool italic = false,
    bool strike = false,
  }) {
    return MarkdownInlineSpan(
      type,
      text,
      href: href,
      bold: this.bold || bold,
      italic: this.italic || italic,
      strike: this.strike || strike,
    );
  }
}

class MarkdownInlineParser {

  static List<MarkdownInlineSpan> parse(String text) {
    final spans = <MarkdownInlineSpan>[];
    var i = 0;
    final buffer = StringBuffer();

    void flush() {
      if (buffer.isNotEmpty) {
        spans.add(
          MarkdownInlineSpan(MarkdownInlineType.text, buffer.toString()),
        );
        buffer.clear();
      }
    }

    List<MarkdownInlineSpan> emphasize(
      String inner, {
      bool bold = false,
      bool italic = false,
      bool strike = false,
    }) {
      return parse(inner)
          .map(
            (span) => span._withExtraEmphasis(
              bold: bold,
              italic: italic,
              strike: strike,
            ),
          )
          .toList();
    }

    while (i < text.length) {
      if (text[i] == '\\' && i + 1 < text.length) {
        buffer.write(text[i + 1]);
        i += 2;
        continue;
      }

      if (text[i] == '`') {
        final end = text.indexOf('`', i + 1);
        if (end != -1) {
          flush();
          spans.add(
            MarkdownInlineSpan(
              MarkdownInlineType.code,
              text.substring(i + 1, end),
            ),
          );
          i = end + 1;
          continue;
        }
      }

      if (text.startsWith('***', i) || text.startsWith('___', i)) {
        final marker = text.substring(i, i + 3);
        final end = text.indexOf(marker, i + 3);
        if (end != -1) {
          flush();
          spans.addAll(
            emphasize(text.substring(i + 3, end), bold: true, italic: true),
          );
          i = end + 3;
          continue;
        }
      }

      if (text.startsWith('~~', i)) {
        final end = text.indexOf('~~', i + 2);
        if (end != -1) {
          flush();
          spans.addAll(emphasize(text.substring(i + 2, end), strike: true));
          i = end + 2;
          continue;
        }
      }

      if (text.startsWith('**', i) || text.startsWith('__', i)) {
        final marker = text.substring(i, i + 2);
        final end = text.indexOf(marker, i + 2);
        if (end != -1) {
          flush();
          spans.addAll(emphasize(text.substring(i + 2, end), bold: true));
          i = end + 2;
          continue;
        }
      }

      if (text[i] == '[') {
        final closeBracket = text.indexOf(']', i + 1);
        if (closeBracket != -1 &&
            closeBracket + 1 < text.length &&
            text[closeBracket + 1] == '(') {
          final closeParen = text.indexOf(')', closeBracket + 2);
          if (closeParen != -1) {
            flush();
            final label = text.substring(i + 1, closeBracket);
            final href = text.substring(closeBracket + 2, closeParen);
            spans.add(
              MarkdownInlineSpan(MarkdownInlineType.link, label, href: href),
            );
            i = closeParen + 1;
            continue;
          }
        }
      }

      if (text[i] == '*' || text[i] == '_') {
        final marker = text[i];
        final end = text.indexOf(marker, i + 1);
        final followedByWord =
            end != -1 &&
            end + 1 < text.length &&
            RegExp(r'\w').hasMatch(text[end + 1]);
        if (end != -1 && end > i + 1 && !followedByWord) {
          flush();
          spans.addAll(emphasize(text.substring(i + 1, end), italic: true));
          i = end + 1;
          continue;
        }
      }

      buffer.write(text[i]);
      i++;
    }
    flush();
    return spans;
  }
}
