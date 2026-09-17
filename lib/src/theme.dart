import 'package:flutter/material.dart';

class DocColors {
  final Color bgDeepest;
  final Color bg;
  final Color bgElevated;
  final Color bgElevated2;
  final Color cardBg;
  final Color codeBg;
  final Color codeBorder;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color heading;
  final Color accent;
  final Color accentStrong;
  final Color accent2;
  final Color border;
  final Color borderStrong;

  const DocColors({
    required this.bgDeepest,
    required this.bg,
    required this.bgElevated,
    required this.bgElevated2,
    required this.cardBg,
    required this.codeBg,
    required this.codeBorder,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.heading,
    required this.accent,
    required this.accentStrong,
    required this.accent2,
    required this.border,
    required this.borderStrong,
  });

  static const dark = DocColors(
    bgDeepest: Color(0xFF100D09),
    bg: Color(0xFF14110C),
    bgElevated: Color(0xFF1C1810),
    bgElevated2: Color(0xFF262013),
    cardBg: Color(0xFF1C1810),
    codeBg: Color(0xFF1A160E),
    codeBorder: Color(0xFF33291A),
    text: Color(0xFFE9DFC8),
    textMuted: Color(0xFFA8987A),
    textFaint: Color(0xFF5C5138),
    heading: Color(0xFFF3E6C4),
    accent: Color(0xFFD4A857),
    accentStrong: Color(0xFFE6BD6C),
    accent2: Color(0xFFC97B5C),
    border: Color(0xFF332918),
    borderStrong: Color(0xFF453720),
  );

  static const light = DocColors(
    bgDeepest: Color(0xFFE9DDC0),
    bg: Color(0xFFFAF6EC),
    bgElevated: Color(0xFFF3ECDC),
    bgElevated2: Color(0xFFEDE2C9),
    cardBg: Color(0xFFFFFFFF),
    codeBg: Color(0xFFF1E8D2),
    codeBorder: Color(0xFFDDCCA3),
    text: Color(0xFF2B2417),
    textMuted: Color(0xFF6B5D45),
    textFaint: Color(0xFF93805C),
    heading: Color(0xFF241D10),
    accent: Color(0xFF9C6B2E),
    accentStrong: Color(0xFF7A5322),
    accent2: Color(0xFF7A3B2E),
    border: Color(0xFFE2D5B8),
    borderStrong: Color(0xFFCDBB90),
  );
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 16.0;
  static const s4 = 24.0;
  static const s5 = 32.0;
  static const s6 = 48.0;
  static const s7 = 64.0;
  static const sm = 10.0;
  static const lg = 20.0;
  static const pill = 999.0;
  static const sidebarWidth = 300.0;
  static const headerHeight = 64.0;
  static const maxDocWidth = 1600.0;
  static const maxPageWidth = 1100.0;
  static const wideBreakpoint = 900.0;
  static const fast = Duration(milliseconds: 150);
  static const med = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 400);
  static const curve = Curves.fastOutSlowIn;
  static const sans = 'Space Grotesk';
  static const mono = 'JetBrains Mono';
}

@immutable
class DocSurfaces extends ThemeExtension<DocSurfaces> {
  final Color cardBg;
  final Color codeBg;
  final Color codeBorder;
  final Color heading;
  final Color textFaint;

  const DocSurfaces({
    required this.cardBg,
    required this.codeBg,
    required this.codeBorder,
    required this.heading,
    required this.textFaint,
  });

  factory DocSurfaces.from(DocColors c) => DocSurfaces(
    cardBg: c.cardBg,
    codeBg: c.codeBg,
    codeBorder: c.codeBorder,
    heading: c.heading,
    textFaint: c.textFaint,
  );

  @override
  DocSurfaces copyWith({
    Color? cardBg,
    Color? codeBg,
    Color? codeBorder,
    Color? heading,
    Color? textFaint,
  }) => DocSurfaces(
    cardBg: cardBg ?? this.cardBg,
    codeBg: codeBg ?? this.codeBg,
    codeBorder: codeBorder ?? this.codeBorder,
    heading: heading ?? this.heading,
    textFaint: textFaint ?? this.textFaint,
  );

  @override
  DocSurfaces lerp(ThemeExtension<DocSurfaces>? other, double t) {
    if (other is! DocSurfaces) return this;
    return DocSurfaces(
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      codeBg: Color.lerp(codeBg, other.codeBg, t)!,
      codeBorder: Color.lerp(codeBorder, other.codeBorder, t)!,
      heading: Color.lerp(heading, other.heading, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
    );
  }
}

ThemeData _buildTheme(Brightness brightness, DocColors c) {
  final scheme = ColorScheme(
    brightness: brightness,
    surfaceDim: c.bgDeepest,
    surface: c.bg,
    surfaceBright: c.bgElevated2,
    surfaceContainerLowest: c.bgDeepest,
    surfaceContainerLow: c.bg,
    surfaceContainer: c.bgElevated,
    surfaceContainerHigh: c.bgElevated2,
    surfaceContainerHighest: c.bgElevated2,
    onSurface: c.text,
    onSurfaceVariant: c.textMuted,
    primary: c.accent,
    onPrimary: brightness == Brightness.dark ? c.bgDeepest : Colors.white,
    primaryContainer: c.accentStrong,
    onPrimaryContainer: brightness == Brightness.dark
        ? c.bgDeepest
        : Colors.white,
    secondary: c.accent2,
    onSecondary: brightness == Brightness.dark ? c.bgDeepest : Colors.white,
    tertiary: c.accentStrong,
    onTertiary: brightness == Brightness.dark ? c.bgDeepest : Colors.white,
    outline: c.borderStrong,
    outlineVariant: c.border,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: c.text,
    onInverseSurface: c.bg,
    inversePrimary: c.accentStrong,
    error: c.accent2,
    onError: brightness == Brightness.dark ? c.bgDeepest : Colors.white,
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    fontFamily: DocColors.sans,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    dividerColor: c.border,
    extensions: [DocSurfaces.from(c)],
    cardTheme: CardThemeData(
      color: c.cardBg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DocColors.sm),
        side: BorderSide(color: c.border),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.border, thickness: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.heading,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: DocColors.sans,
        fontWeight: FontWeight.w700,
        fontSize: 19,
        color: c.heading,
      ),
      iconTheme: IconThemeData(color: c.textMuted),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.8,
        color: c.text,
      ),
      bodyMedium: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.7,
        color: c.text,
      ),
      bodySmall: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.6,
        color: c.textMuted,
      ),
      headlineLarge: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0.3,
        color: c.heading,
      ),
      headlineMedium: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0.25,
        color: c.heading,
      ),
      headlineSmall: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0.2,
        color: c.heading,
      ),
      titleMedium: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: c.heading,
      ),
      labelLarge: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: c.text,
      ),
      labelMedium: TextStyle(
        fontFamily: DocColors.sans,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: c.textMuted,
      ),
      labelSmall: TextStyle(
        fontFamily: DocColors.mono,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: c.textFaint,
      ),
    ),
  );
}

final ThemeData lightTheme = _buildTheme(Brightness.light, DocColors.light);
final ThemeData darkTheme = _buildTheme(Brightness.dark, DocColors.dark);

extension DocColorsContext on BuildContext {
  DocSurfaces get docSurfaces => Theme.of(this).extension<DocSurfaces>()!;
}
