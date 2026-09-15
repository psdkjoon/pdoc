import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

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
        const SizedBox(width: 16),
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
    final shift = widget.isPrevious ? -1.0 : 1.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.target.$1, widget.target.$2),
        child: AnimatedContainer(
          duration: DocColors.fast,
          curve: DocColors.curve,
          transform: Matrix4.translationValues(_hovered ? shift * 3 : 0, 0, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            border: Border.all(
              color: _hovered ? scheme.primary : scheme.outlineVariant,
              width: _hovered ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(DocColors.sm),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
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
                      size: 13,
                      color: scheme.primary,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      widget.isPrevious ? 'Previous' : 'Next',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (!widget.isPrevious)
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: scheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.target.$2,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? scheme.primary : scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
