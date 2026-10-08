import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/logic/searchbar_controller.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';
import 'package:pdoc/widgets/reveal.dart';

class DocsCards extends StatelessWidget {
  final Docs docs;
  final void Function(Doc doc) onOpen;
  final bool isWide;

  const DocsCards({
    super.key,
    required this.docs,
    required this.onOpen,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
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
        return Padding(
          padding: const EdgeInsets.only(top: DocValues.s1),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  (constraints.maxWidth / DocValues.cardMinWidth).floor().clamp(
                    DocValues.firstColumn,
                    DocValues.cardMaxColumns,
                  );
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context)
                    .copyWith(scrollbars: false),
                child: GridView.builder(
                  padding: const EdgeInsets.only(
                    top: DocValues.s2,
                    left: DocValues.s3,
                    right: DocValues.s3,
                    bottom: DocValues.s3,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: DocValues.cardGridGap,
                    mainAxisSpacing: DocValues.cardGridGap,
                    childAspectRatio: isWide
                        ? DocValues.cardAspectWide
                        : DocValues.cardAspectCompact,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    return Reveal(
                      key: ValueKey<String>(doc['title'] as String),
                      delay: staggerDelay(index),
                      dy: 18,
                      child: DocCard(doc: doc, onTap: () => onOpen(doc)),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
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
    final title = widget.doc['title'] as String;
    final description = widget.doc['description'] as String;

    return Semantics(
      button: true,
      label: '$title. $description',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _entered = true),
          onExit: (_) => setState(() => _entered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: DocValues.hover,
            curve: DocValues.curveHover,
            transform: Matrix4.translationValues(
              DocValues.s0,
              _entered ? DocValues.hoverLift : DocValues.s0,
              DocValues.s0,
            ),
            padding: const EdgeInsets.all(DocValues.s35),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              border: Border.all(
                color: _entered ? scheme.primary : scheme.outline,
                width: DocValues.borderMed,
              ),
              borderRadius: BorderRadius.circular(DocValues.rCode),
              boxShadow: _entered
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(
                          alpha: DocValues.alphaShadowStrong,
                        ),
                        blurRadius: DocValues.glowBlur,
                        spreadRadius: DocValues.glowSpread,
                      ),
                    ]
                  : const [],
            ),
            child: LayoutBuilder(
              builder: (context, box) => _CardBody(
                title: title,
                description: description,
                height: box.maxHeight,
                scheme: scheme,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final String title;
  final String description;
  final double height;
  final ColorScheme scheme;

  const _CardBody({
    required this.title,
    required this.description,
    required this.height,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: DocValues.fsCardTitle,
      fontWeight: DocValues.fwBold,
      color: scheme.onSurface,
    );
    final descStyle = TextStyle(
      color: scheme.onSurfaceVariant,
      fontSize: DocValues.fsBody,
      height: DocValues.lhRelaxed,
    );
    final ctaStyle = TextStyle(
      color: scheme.primary,
      fontWeight: DocValues.fwSemi,
      fontSize: DocValues.fsBody2,
    );

    final titleHeight = DocValues.fsCardTitle * DocValues.lhTight;
    final ctaHeight = DocValues.fsBody2 * DocValues.lhRelaxed;
    final descLine = DocValues.fsBody * DocValues.lhRelaxed;

    final room = height - titleHeight - ctaHeight - DocValues.s2 - DocValues.s2;
    final lines = (room / descLine).floor().clamp(
      DocValues.noLines,
      DocValues.maxLinesCard,
    );
    final showDescription = lines > DocValues.noLines;
    final showCta = height >= titleHeight + ctaHeight + DocValues.s2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FitText(title, style: titleStyle, minFontSize: DocValues.fsBodyLg),
        if (showDescription) ...[
          const SizedBox(height: DocValues.s2),
          Text(
            description,
            maxLines: lines,
            overflow: TextOverflow.ellipsis,
            style: descStyle,
          ),
        ],
        if (showCta) ...[
          const SizedBox(height: DocValues.s2),
          FitText('View docs →', style: ctaStyle),
        ],
      ],
    );
  }
}
