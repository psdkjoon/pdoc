import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';

class DocPrevNextNav extends StatelessWidget {
  final List<(String, String)> pages;
  final (String, String) current;
  final void Function(String section, String page) onSelect;

  const DocPrevNextNav({
    super.key,
    required this.pages,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final index = pages.indexWhere((page) => page == current);
    final previous = index > 0 ? pages[index - 1] : null;
    final next = (index != -1 && index < pages.length - 1)
        ? pages[index + 1]
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < DocValues.mediumBreakpoint;
        final cards = <Widget>[
          if (previous != null)
            _NavCard(target: previous, isPrevious: true, onTap: onSelect),
          if (next != null)
            _NavCard(target: next, isPrevious: false, onTap: onSelect),
        ];

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: DocValues.s3),
                cards[i],
              ],
            ],
          );
        }

        return Row(
          children: [
            if (previous != null)
              Expanded(
                child: _NavCard(
                  target: previous,
                  isPrevious: true,
                  onTap: onSelect,
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: DocValues.s3),
            if (next != null)
              Expanded(
                child: _NavCard(
                  target: next,
                  isPrevious: false,
                  onTap: onSelect,
                ),
              )
            else
              const Spacer(),
          ],
        );
      },
    );
  }
}

class _NavCard extends StatefulWidget {
  final (String, String) target;
  final bool isPrevious;
  final void Function(String section, String page) onTap;

  const _NavCard({
    required this.target,
    required this.isPrevious,
    required this.onTap,
  });

  @override
  State<_NavCard> createState() => _NavCardState();
}

class _NavCardState extends State<_NavCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shift = widget.isPrevious
        ? -DocValues.hoverNudge
        : DocValues.hoverNudge;
    final align = widget.isPrevious ? TextAlign.start : TextAlign.end;

    return Semantics(
      button: true,
      label: '${widget.isPrevious ? 'Previous' : 'Next'}: ${widget.target.$2}',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.onTap(widget.target.$1, widget.target.$2),
          child: AnimatedContainer(
            duration: DocValues.fast,
            curve: DocValues.curve,
            transform: Matrix4.translationValues(
              _hovered ? shift : DocValues.s0,
              DocValues.s0,
              DocValues.s0,
            ),
            padding: const EdgeInsets.all(DocValues.s3),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              border: Border.all(
                color: _hovered ? scheme.primary : scheme.outlineVariant,
                width: _hovered
                    ? DocValues.borderThickHover
                    : DocValues.borderThin,
              ),
              borderRadius: BorderRadius.circular(DocValues.sm),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(
                          alpha: DocValues.alphaShadowSoft,
                        ),
                        blurRadius: DocValues.liftBlur,
                        offset: const Offset(
                          DocValues.s0,
                          DocValues.liftOffsetY,
                        ),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              crossAxisAlignment: widget.isPrevious
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isPrevious)
                      Icon(
                        Icons.arrow_back_rounded,
                        size: DocValues.iconTiny,
                        color: scheme.primary,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DocValues.s1,
                      ),
                      child: Text(
                        widget.isPrevious ? 'Previous' : 'Next',
                        style: TextStyle(
                          fontSize: DocValues.fsMicro,
                          fontWeight: DocValues.fwSemi,
                          letterSpacing: DocValues.lsWide,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (!widget.isPrevious)
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: DocValues.iconTiny,
                        color: scheme.primary,
                      ),
                  ],
                ),
                const SizedBox(height: DocValues.s1),
                SizedBox(
                  width: double.infinity,
                  child: WrapText(
                    widget.target.$2,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: DocValues.fsBody,
                      fontWeight: DocValues.fwBold,
                      color: _hovered ? scheme.primary : scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
