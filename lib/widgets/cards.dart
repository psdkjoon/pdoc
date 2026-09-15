import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/logic/searchbar_controller.dart';

class DocsCards extends StatelessWidget {
  final Docs docs;
  final void Function(Doc doc) onOpen;

  const DocsCards({super.key, required this.docs, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: ValueListenableBuilder<String>(
          valueListenable: searchBarNotifier,
          builder: (context, query, _) {
            final queryLowerCase = query.toLowerCase();
            final titleMatches = <Doc>[], descMatches = <Doc>[];
            for (final doc in docs) {
              final title = (doc['title'] as String).toLowerCase();
              if (title.contains(queryLowerCase)) {
                titleMatches.add(doc);
              } else if ((doc['description'] as String).toLowerCase().contains(
                queryLowerCase,
              )) {
                descMatches.add(doc);
              }
            }
            final filtered = titleMatches + descMatches;
            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 300)
                    .floor()
                    .clamp(1, 10)
                    .toInt();
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    return DocCard(doc: doc, onTap: () => onOpen(doc));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DocCard extends StatefulWidget {
  final Doc doc;
  final VoidCallback onTap;

  const DocCard({super.key, required this.doc, required this.onTap});

  @override
  State<DocCard> createState() => _DocCardState();
}

class _DocCardState extends State<DocCard> {
  bool _entered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _entered = true),
        onExit: (_) => setState(() => _entered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _entered ? -2 : 0, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            border: Border.all(
              color: _entered ? scheme.primary : scheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _entered
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doc['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  widget.doc['description'] as String,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'View docs →',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
