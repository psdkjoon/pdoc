import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/logic/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _ThemeOption(
            mode: ThemeMode.light,
            scheme: scheme,
            radius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            icon: '''<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="4"></circle><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"></path></svg>''',
          ),
          Container(width: 3, color: scheme.outline),
          _ThemeOption(
            mode: ThemeMode.dark,
            scheme: scheme,
            radius: const BorderRadius.only(
              bottomRight: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            icon: '''<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.6A9 9 0 1 1 11.4 3a7 7 0 0 0 9.6 9.6Z"></path></svg>''',
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final ThemeMode mode;
  final ColorScheme scheme;
  final BorderRadius radius;
  final String icon;

  const _ThemeOption({
    required this.mode,
    required this.scheme,
    required this.radius,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = scheme.brightness == Brightness.dark;
    final selected = isDark ? mode == ThemeMode.dark : mode == ThemeMode.light;

    return GestureDetector(
      onTap: () => setThemeMode(mode),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: selected ? scheme.primary : scheme.surfaceContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.string(
            icon,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              selected ? scheme.surface : scheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
