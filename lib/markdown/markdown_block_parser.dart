import 'package:pdoc/markdown/markdown_block.dart';

class MarkdownBlockParser {
  static final _bulletMatch = RegExp(r'^(\s*)([-*+])\s+(.*)$');
  static final _orderedMatch = RegExp(r'^(\s*)(\d+)[.)]\s+(.*)$');
  static final _ruleMatch = RegExp(r'^\s*([-*_])(\s*\1){2,}\s*$');
  static final _imageMatch = RegExp(r'^!\[([^\]]*)\]\(([^)]+)\)$');
  static final _tableSeparator = RegExp(r'^\s*\|?[\s:|-]+\|?\s*$');
  static final _linkCardMatch = RegExp(
    r'\[(#{1,6}\s+[^\n]+)\n\n((?:(?!\]\().)+)\]\(([^)\n]+)\)',
    dotAll: true,
  );

  static List<MarkdownBlock> parse(String source) {
    final normalized = source.replaceAll('\r\n', '\n');
    final blocks = <MarkdownBlock>[];
    var cursor = 0;

    for (final match in _linkCardMatch.allMatches(normalized)) {
      if (match.start > cursor) {
        blocks.addAll(_parseLines(normalized.substring(cursor, match.start)));
      }
      final heading = match
          .group(1)!
          .replaceFirst(RegExp(r'^#{1,6}\s+'), '')
          .trim();
      final body = match.group(2)!.trim();
      final href = match.group(3)!.trim();
      blocks.add(MarkdownBlock.linkCard(heading, body, href));
      cursor = match.end;
    }
    if (cursor < normalized.length) {
      blocks.addAll(_parseLines(normalized.substring(cursor)));
    }

    return blocks;
  }

  static List<MarkdownBlock> _parseLines(String source) {
    final lines = source.split('\n');
    final blocks = <MarkdownBlock>[];
    var i = 0;

    while (i < lines.length) {
      final line = lines[i];

      if (line.trim().isEmpty) {
        i++;
        continue;
      }

      if (line.trimLeft().startsWith('```')) {
        final lang = line.trimLeft().substring(3).trim();
        final buffer = <String>[];
        i++;
        while (i < lines.length && !lines[i].trimLeft().startsWith('```')) {
          buffer.add(lines[i]);
          i++;
        }
        if (i < lines.length) i++;
        blocks.add(
          MarkdownBlock.code(buffer.join('\n'), lang.isEmpty ? null : lang),
        );
        continue;
      }

      if (_ruleMatch.hasMatch(line)) {
        blocks.add(MarkdownBlock.rule());
        i++;
        continue;
      }

      final imageOnlyLine = _imageMatch.firstMatch(line.trim());
      if (imageOnlyLine != null) {
        blocks.add(
          MarkdownBlock.image(imageOnlyLine.group(1)!, imageOnlyLine.group(2)!),
        );
        i++;
        continue;
      }

      if (line.startsWith('### ')) {
        blocks.add(
          MarkdownBlock.heading(MarkdownBlockType.h3, line.substring(4).trim()),
        );
        i++;
        continue;
      }
      if (line.startsWith('## ')) {
        blocks.add(
          MarkdownBlock.heading(MarkdownBlockType.h2, line.substring(3).trim()),
        );
        i++;
        continue;
      }
      if (line.startsWith('# ')) {
        blocks.add(
          MarkdownBlock.heading(MarkdownBlockType.h1, line.substring(2).trim()),
        );
        i++;
        continue;
      }

      if (line.trimLeft().startsWith('>')) {
        final buffer = <String>[];
        while (i < lines.length && lines[i].trimLeft().startsWith('>')) {
          buffer.add(lines[i].trimLeft().replaceFirst(RegExp(r'^>\s?'), ''));
          i++;
        }
        blocks.add(MarkdownBlock.blockquote(buffer.join(' ')));
        continue;
      }

      if (line.trimLeft().startsWith('|') &&
          i + 1 < lines.length &&
          _tableSeparator.hasMatch(lines[i + 1])) {
        final rows = <List<String>>[_splitTableRow(line)];
        i += 2;
        while (i < lines.length && lines[i].trimLeft().startsWith('|')) {
          rows.add(_splitTableRow(lines[i]));
          i++;
        }
        blocks.add(MarkdownBlock.table(rows));
        continue;
      }

      if (_bulletMatch.hasMatch(line) || _orderedMatch.hasMatch(line)) {
        final ordered = _orderedMatch.hasMatch(line);
        final firstMatch = ordered
            ? _orderedMatch.firstMatch(line)!
            : _bulletMatch.firstMatch(line)!;
        final startNumber = int.tryParse(firstMatch.group(2) ?? '') ?? 1;
        final items = <String>[];
        while (i < lines.length) {
          final match = ordered
              ? _orderedMatch.firstMatch(lines[i])
              : _bulletMatch.firstMatch(lines[i]);
          if (match == null) break;
          var text = match.group(3)!;
          i++;
          while (i < lines.length &&
              lines[i].trim().isNotEmpty &&
              (lines[i].startsWith('  ') || lines[i].startsWith('\t')) &&
              !_bulletMatch.hasMatch(lines[i]) &&
              !_orderedMatch.hasMatch(lines[i])) {
            text += ' ${lines[i].trim()}';
            i++;
          }
          items.add(text);
        }
        blocks.add(MarkdownBlock.list(items, ordered, startNumber));
        continue;
      }

      final buffer = <String>[line];
      i++;
      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          !lines[i].startsWith('#') &&
          !lines[i].trimLeft().startsWith('```') &&
          !lines[i].trimLeft().startsWith('|') &&
          !_bulletMatch.hasMatch(lines[i]) &&
          !_orderedMatch.hasMatch(lines[i]) &&
          !lines[i].trimLeft().startsWith('>') &&
          !_ruleMatch.hasMatch(lines[i]) &&
          !_imageMatch.hasMatch(lines[i].trim())) {
        buffer.add(lines[i]);
        i++;
      }
      blocks.add(MarkdownBlock.paragraph(buffer.join(' ')));
    }

    return blocks;
  }

  static List<String> _splitTableRow(String line) {
    var trimmed = line.trim();
    if (trimmed.startsWith('|')) trimmed = trimmed.substring(1);
    if (trimmed.endsWith('|')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    final cells = <String>[];
    final buffer = StringBuffer();
    var inCode = false;
    for (var i = 0; i < trimmed.length; i++) {
      final char = trimmed[i];
      if (char == '`') {
        inCode = !inCode;
        buffer.write(char);
      } else if (char == '\\' &&
          i + 1 < trimmed.length &&
          trimmed[i + 1] == '|') {
        buffer.write('|');
        i++;
      } else if (char == '|' && !inCode) {
        cells.add(buffer.toString().trim());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    cells.add(buffer.toString().trim());
    return cells;
  }
}
