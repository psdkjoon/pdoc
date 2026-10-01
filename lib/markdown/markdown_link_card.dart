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
    this.headingFontSize = DocValues.fsTitleSm,
    this.bodyFontSize = DocValues.fsBody,
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
    final highlighted = _hovered || _focused;
    return Semantics(
      link: true,
      child: Material(
        color: scheme.surfaceContainer,
        animationDuration: DocValues.fast,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DocValues.lg),
          side: BorderSide(
            color: highlighted ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(DocValues.lg),
          hoverColor: scheme.primary.withValues(alpha: DocValues.alphaHover),
          focusColor: scheme.primary.withValues(alpha: DocValues.alphaFocus),
          child: ExcludeFocus(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(DocValues.s4),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MarkdownInlineText(
                        spans: widget.headingSpans,
                        baseStyle: TextStyle(
                          fontSize: widget.headingFontSize,
                          fontWeight: DocValues.fwBold,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: DocValues.s2),
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
      ),
    );
  }
}
