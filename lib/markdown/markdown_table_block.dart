import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_inline.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownTableBlock extends StatelessWidget {
  final List<List<String>> rows;
  final double fontSize;
  final void Function(String href)? onLinkTap;

  const MarkdownTableBlock({
    super.key,
    required this.rows,
    this.fontSize = 15,
    this.onLinkTap,
  });

  static List<String> _normalizeRow(List<String> row, int columnCount) {
    if (row.length == columnCount) return row;
    if (row.length > columnCount) return row.sublist(0, columnCount);
    return [...row, ...List.filled(columnCount - row.length, '')];
  }

  Widget _cell(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: MarkdownInlineText(
        spans: MarkdownInlineParser.parse(text),
        baseStyle: style,
        textAlign: TextAlign.center,
        onLinkTap: onLinkTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final docSurfaces = context.docSurfaces;
    final columnCount = rows.first.length;
    final header = _normalizeRow(rows.first, columnCount);
    final body = rows
        .skip(1)
        .map((row) => _normalizeRow(row, columnCount))
        .toList();
    final bodyStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(fontSize: fontSize);
    final headingStyle = bodyStyle.copyWith(
      fontWeight: FontWeight.w700,
      color: docSurfaces.heading,
    );

    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DocColors.sm),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(DocColors.sm),
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            defaultColumnWidth: const FlexColumnWidth(),
            border: TableBorder(
              horizontalInside: BorderSide(color: scheme.outlineVariant),
              verticalInside: BorderSide(color: scheme.outlineVariant),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(color: scheme.surfaceContainerHigh),
                children: [
                  for (final cell in header) _cell(cell, headingStyle),
                ],
              ),
              for (final row in body)
                TableRow(
                  decoration: BoxDecoration(color: scheme.surfaceContainer),
                  children: [for (final cell in row) _cell(cell, bodyStyle)],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
