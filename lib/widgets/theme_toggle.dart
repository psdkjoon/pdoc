import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/logic/theme_controller.dart';
import 'package:pdoc/src/theme.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  static const _sunIcon =
      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
      'stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="4">'
      '</circle><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 '
      '12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"></path></svg>';

  static const _moonIcon =
      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
      'stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M21 12.6A9 9 0 1 1 11.4 3a7 7 0 0 0 9.6 9.6Z"></path></svg>';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const innerRadius = Radius.circular(DocValues.rXs);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: DocValues.borderThick),
        borderRadius: BorderRadius.circular(DocValues.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeOption(
            mode: ThemeMode.light,
            label: 'Light theme',
            scheme: scheme,
            radius: const BorderRadius.horizontal(left: innerRadius),
            icon: _sunIcon,
          ),
          Container(width: DocValues.borderThick, color: scheme.outline),
          _ThemeOption(
            mode: ThemeMode.dark,
            label: 'Dark theme',
            scheme: scheme,
            radius: const BorderRadius.horizontal(right: innerRadius),
            icon: _moonIcon,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final ColorScheme scheme;
  final BorderRadius radius;
  final String icon;

  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.scheme,
    required this.radius,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = scheme.brightness == Brightness.dark;
    final selected = isDark ? mode == ThemeMode.dark : mode == ThemeMode.light;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setThemeMode(mode),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: selected ? scheme.primary : scheme.surfaceContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(DocValues.sPx3),
              child: SvgPicture.string(
                icon,
                width: DocValues.iconGlyph,
                height: DocValues.iconGlyph,
                colorFilter: ColorFilter.mode(
                  selected ? scheme.surface : scheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
