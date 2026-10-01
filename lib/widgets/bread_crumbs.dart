import 'package:flutter/material.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';

class DocBreadcrumb extends StatelessWidget {
  final DocPageArgs args;
  final String section;

  const DocBreadcrumb({super.key, required this.args, required this.section});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontSize: DocValues.fsSmall,
      color: scheme.onSurfaceVariant,
    );
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(args.projectTitle, style: style),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DocValues.s15),
          child: Text('/', style: style.copyWith(color: scheme.outlineVariant)),
        ),
        Text(section, style: style),
      ],
    );
  }
}
