import 'package:flutter/material.dart';
import 'package:pdoc/logic/font_size_controller.dart';

class FontSizeToggle extends StatelessWidget {
  const FontSizeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<DocFontSize>(
      valueListenable: fontSizeNotifier,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant, width: 3),
            borderRadius: BorderRadius.circular(8),
            color: scheme.surfaceContainer,
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < DocFontSize.values.length; i++)
                Container(
                  decoration: BoxDecoration(
                    border: i < DocFontSize.values.length - 1
                        ? Border(
                            right: BorderSide(color: scheme.outlineVariant),
                          )
                        : null,
                  ),
                  child: _FontSizeOption(
                    size: DocFontSize.values[i],
                    selected: DocFontSize.values[i] == value,
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

  const _FontSizeOption({required this.size, required this.selected});

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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => setFontSize(widget.size),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: widget.selected ? scheme.primary : Colors.transparent,
          child: Text(
            'A',
            style: TextStyle(
              fontSize: widget.size.labelFontSize,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
