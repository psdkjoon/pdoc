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
    this.fontSize = DocValues.fsBody,
    this.onLinkTap,
  });

  static List<String> _normalizeRow(List<String> row, int columnCount) {
    if (row.length == columnCount) return row;
    if (row.length > columnCount) return row.sublist(0, columnCount);
    return [...row, ...List.filled(columnCount - row.length, '')];
  }

  Widget _cell(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DocValues.s35,
        vertical: DocValues.s28,
      ),
      child: MarkdownInlineText(
        spans: MarkdownInlineParser.parse(text),
        baseStyle: style,
        textAlign: TextAlign.start,
        onLinkTap: onLinkTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final columnCount = rows.first.length;
    final header = _normalizeRow(rows.first, columnCount);
    final body = rows
        .skip(1)
        .map((row) => _normalizeRow(row, columnCount))
        .toList();
    final bodyStyle = Theme.of(context).textTheme.bodyMedium!
        .copyWith(fontSize: fontSize);
    final headingStyle = bodyStyle.copyWith(
      fontWeight: DocValues.fwBold,
      color: scheme.primary,
      letterSpacing: DocValues.lsTight,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidth = DocValues.tableMinColumn * columnCount;
        final scrolls = constraints.maxWidth < minWidth;
        final tableWidth = scrolls ? minWidth : constraints.maxWidth;

        final radius = BorderRadius.circular(DocValues.rCode);
        final table = Container(
          width: tableWidth,
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: DocValues.shadowColor.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(DocValues.s0, DocValues.s1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              defaultColumnWidth: const FlexColumnWidth(),
              border: TableBorder(
                horizontalInside: BorderSide(color: scheme.outlineVariant),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                  ),
                  children: [
                    for (final cell in header) _cell(cell, headingStyle),
                  ],
                ),
                for (var i = 0; i < body.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: i.isEven
                          ? scheme.surfaceContainer
                          : scheme.surfaceContainerHigh.withValues(alpha: 0.6),
                    ),
                    children: [
                      for (final cell in body[i]) _cell(cell, bodyStyle),
                    ],
                  ),
              ],
            ),
          ),
        );

        if (!scrolls) return table;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: table,
        );
      },
    );
  }
}
