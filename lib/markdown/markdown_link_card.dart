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
    final radius = BorderRadius.circular(DocValues.rCode);
    return Semantics(
      link: true,
      child: AnimatedContainer(
        duration: DocValues.hover,
        curve: DocValues.curveHover,
        transform: Matrix4.translationValues(
          DocValues.s0,
          highlighted ? DocValues.hoverLift : DocValues.s0,
          DocValues.s0,
        ),
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: highlighted
                  ? scheme.primary.withValues(alpha: 0.22)
                  : DocValues.shadowColor.withValues(alpha: 0.08),
              blurRadius: highlighted ? 24 : 14,
              offset: const Offset(DocValues.s0, DocValues.s1),
            ),
          ],
        ),
        child: Material(
          color: scheme.surfaceContainer,
          animationDuration: DocValues.fast,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: highlighted ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            mouseCursor: SystemMouseCursors.click,
            borderRadius: radius,
            hoverColor: scheme.primary.withValues(alpha: DocValues.alphaHover),
            focusColor: scheme.primary.withValues(alpha: DocValues.alphaFocus),
            child: ExcludeFocus(
              child: IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DocValues.s4,
                    vertical: DocValues.s35,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MarkdownInlineText(
                              spans: widget.headingSpans,
                              baseStyle: TextStyle(
                                fontSize: widget.headingFontSize,
                                fontWeight: DocValues.fwBold,
                                color: highlighted
                                    ? scheme.primary
                                    : scheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: DocValues.s15),
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
                      const SizedBox(width: DocValues.s3),
                      AnimatedContainer(
                        duration: DocValues.hover,
                        curve: DocValues.curveHover,
                        transform: Matrix4.translationValues(
                          highlighted ? DocValues.hoverNudge * 2 : DocValues.s0,
                          DocValues.s0,
                          DocValues.s0,
                        ),
                        padding: const EdgeInsets.all(DocValues.s15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: highlighted
                              ? scheme.primary
                              : scheme.primary.withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: DocValues.iconMedium,
                          color: highlighted
                              ? scheme.onPrimary
                              : scheme.primary,
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
