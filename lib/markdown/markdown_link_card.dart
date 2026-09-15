import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_inline.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownLinkCard extends StatefulWidget {
  final String heading;
  final List<MarkdownInlineSpan> bodySpans;
  final VoidCallback onTap;
  final double headingFontSize;
  final double bodyFontSize;

  const MarkdownLinkCard({
    super.key,
    required this.heading,
    required this.bodySpans,
    required this.onTap,
    this.headingFontSize = 17,
    this.bodyFontSize = 15,
  });

  @override
  State<MarkdownLinkCard> createState() => _MarkdownLinkCardState();
}

class _MarkdownLinkCardState extends State<MarkdownLinkCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final docSurfaces = context.docSurfaces;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DocColors.fast,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: docSurfaces.cardBg,
            borderRadius: BorderRadius.circular(DocColors.sm),
            border: Border.all(
              color: _hovered ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.heading,
                style: TextStyle(
                  fontSize: widget.headingFontSize,
                  fontWeight: FontWeight.w700,
                  color: docSurfaces.heading,
                ),
              ),
              const SizedBox(height: 6),
              MarkdownInlineText(
                spans: widget.bodySpans,
                baseStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: widget.bodyFontSize,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
