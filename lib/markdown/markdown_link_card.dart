import 'package:flutter/material.dart';
import 'package:pdoc/markdown/markdown_inline.dart';
import 'package:pdoc/markdown/markdown_inline_text.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownLinkCard extends StatefulWidget {
  final List<MarkdownInlineSpan> headingSpans;
  final List<MarkdownInlineSpan> bodySpans;
  final VoidCallback onTap;
  final double headingFontSize;
  final double bodyFontSize;

  const MarkdownLinkCard({
    super.key,
    required this.headingSpans,
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
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final docSurfaces = context.docSurfaces;
    final highlighted = _hovered || _focused;
    return Semantics(
      link: true,
      child: Material(
        color: docSurfaces.cardBg,
        animationDuration: DocColors.fast,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DocColors.lg),
          side: BorderSide(
            color: highlighted ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(DocColors.lg),
          hoverColor: scheme.primary.withValues(alpha: 0.04),
          focusColor: scheme.primary.withValues(alpha: 0.08),
          child: ExcludeFocus(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(DocColors.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MarkdownInlineText(
                      spans: widget.headingSpans,
                      baseStyle: TextStyle(
                        fontSize: widget.headingFontSize,
                        fontWeight: FontWeight.w700,
                        color: docSurfaces.heading,
                      ),
                    ),
                    const SizedBox(height: DocColors.s2),
                    MarkdownInlineText(
                      spans: widget.bodySpans,
                      baseStyle: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(
                            fontSize: widget.bodyFontSize,
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
