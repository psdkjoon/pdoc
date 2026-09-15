enum MarkdownInlineType { text, bold, italic, boldItalic, code, link, strike }

class MarkdownInlineSpan {
  final MarkdownInlineType type;
  final String text;
  final String? href;

  MarkdownInlineSpan(this.type, this.text, {this.href});
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
          spans.add(
            MarkdownInlineSpan(
              MarkdownInlineType.boldItalic,
              text.substring(i + 3, end),
            ),
          );
          i = end + 3;
          continue;
        }
      }

      if (text.startsWith('~~', i)) {
        final end = text.indexOf('~~', i + 2);
        if (end != -1) {
          flush();
          spans.add(
            MarkdownInlineSpan(
              MarkdownInlineType.strike,
              text.substring(i + 2, end),
            ),
          );
          i = end + 2;
          continue;
        }
      }

      if (text.startsWith('**', i) || text.startsWith('__', i)) {
        final marker = text.substring(i, i + 2);
        final end = text.indexOf(marker, i + 2);
        if (end != -1) {
          flush();
          spans.add(
            MarkdownInlineSpan(
              MarkdownInlineType.bold,
              text.substring(i + 2, end),
            ),
          );
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
          spans.add(
            MarkdownInlineSpan(
              MarkdownInlineType.italic,
              text.substring(i + 1, end),
            ),
          );
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
