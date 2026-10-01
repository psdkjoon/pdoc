import 'package:flutter/material.dart';
import 'package:pdoc/logic/font_size_controller.dart';
import 'package:pdoc/src/theme.dart';

class FontSizeToggle extends StatelessWidget {
  const FontSizeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const sizes = DocFontSize.values;
    const innerRadius = Radius.circular(DocValues.rXs);

    return ValueListenableBuilder<DocFontSize>(
      valueListenable: fontSizeNotifier,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: scheme.outlineVariant,
              width: DocValues.borderThick,
            ),
            borderRadius: BorderRadius.circular(DocValues.rSm),
            color: scheme.surfaceContainer,
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < sizes.length; i++)
                Container(
                  decoration: BoxDecoration(
                    border: i < sizes.length - 1
                        ? Border(
                            right: BorderSide(color: scheme.outlineVariant),
                          )
                        : null,
                  ),
                  child: _FontSizeOption(
                    size: sizes[i],
                    selected: sizes[i] == value,
                    borderRadius: BorderRadius.horizontal(
                      left: i == 0 ? innerRadius : Radius.zero,
                      right: i == sizes.length - 1 ? innerRadius : Radius.zero,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FontSizeOption extends StatefulWidget {
  final DocFontSize size;
  final bool selected;
  final BorderRadius borderRadius;

  const _FontSizeOption({
    required this.size,
    required this.selected,
    required this.borderRadius,
  });

  @override
  State<_FontSizeOption> createState() => _FontSizeOptionState();
}

class _FontSizeOptionState extends State<_FontSizeOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.selected
        ? scheme.surface
        : (_hovered ? scheme.primary : scheme.onSurfaceVariant);

    return Semantics(
      button: true,
      selected: widget.selected,
      label: 'Text size ${widget.size.name}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => setFontSize(widget.size),
          child: AnimatedContainer(
            width: DocValues.toggleCellWidth,
            height: DocValues.toggleCellHeight,
            alignment: Alignment.center,
            duration: DocValues.fast,
            decoration: BoxDecoration(
              color: widget.selected ? scheme.primary : DocValues.transparent,
              borderRadius: widget.borderRadius,
            ),
            child: Text(
              'A',
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: widget.size.labelFontSize,
                fontWeight: DocValues.fwBold,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
