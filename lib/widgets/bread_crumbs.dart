import 'package:flutter/material.dart';
import 'package:pdoc/pages/doc_page.dart';

class DocBreadcrumb extends StatelessWidget {
  final DocPageArgs args;
  final String section;

  const DocBreadcrumb({
    super.key,
    required this.args,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = TextStyle(fontSize: 13, color: scheme.onSurfaceVariant);
    return Row(
      children: [
        Text(args.projectTitle, style: style),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('/', style: style.copyWith(color: scheme.outlineVariant)),
        ),
        Text(section, style: style),
      ],
    );
  }
}
