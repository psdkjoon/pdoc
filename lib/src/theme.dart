import 'package:flutter/material.dart';

class DocValues {
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
  final Color onAccent;

  const DocValues({
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
    required this.onAccent,
  });

  static const dark = DocValues(
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
    onAccent: Color(0xFF100D09),
  );

  static const light = DocValues(
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
    onAccent: Color(0xFFFFFFFF),
  );

  static const shadowColor = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  static const s0 = 0.0;
  static const sHair = 1.0;
  static const sPx2 = 2.0;
  static const sPx3 = 3.0;
  static const s1 = 4.0;
  static const s15 = 6.0;
  static const s2 = 8.0;
  static const s25 = 10.0;
  static const s28 = 12.0;
  static const s3 = 16.0;
  static const s35 = 20.0;
  static const s4 = 24.0;
  static const s5 = 32.0;
  static const s6 = 48.0;
  static const s7 = 64.0;

  static const rXs = 6.0;
  static const rSm = 8.0;
  static const sm = 10.0;
  static const rMd = 12.0;
  static const md = 15.0;
  static const lg = 20.0;
  static const rXl = 24.0;
  static const rCode = 18.0;
  static const pill = 999.0;

  static const borderThin = 1.0;
  static const borderMed = 2.0;
  static const borderThick = 3.0;
  static const borderThickHover = 1.5;

  static const fsMicro = 11.0;
  static const fsCaption = 12.0;
  static const fsSmall = 13.0;
  static const fsBody2 = 14.0;
  static const fsBody = 15.0;
  static const fsTitleSm = 17.0;
  static const fsBodyLg = 18.0;
  static const fsAppBar = 19.0;
  static const fsHeadSm = 21.0;
  static const fsHeadMd = 32.0;
  static const fsHeadLg = 48.0;
  static const fsCardTitle = 24.0;
  static const fsPageTitle = 40.0;
  static const fsHeroCompact = 36.0;
  static const fsHeroWide = 56.0;
  static const fsBrand = 24.0;

  static const readerSmall = 15.0;
  static const readerMedium = 20.0;
  static const readerLarge = 26.0;
  static const readerLabelSmall = 12.0;
  static const readerLabelMedium = 15.0;
  static const readerLabelLarge = 18.0;

  static const fsFloor = 10.0;

  static const lhTight = 1.25;
  static const lhSnug = 1.3;
  static const lhCode = 1.5;
  static const lhRelaxed = 1.6;
  static const lhBody = 1.7;
  static const lhLoose = 1.8;
  static const lsTight = 0.2;
  static const lsHead = 0.25;
  static const lsWide = 0.3;
  static const lsLabel = 0.4;
  static const lsMono = 0.5;

  static const fwRegular = FontWeight.w400;
  static const fwMedium = FontWeight.w500;
  static const fwBold = FontWeight.w700;
  static const fwSemi = fwBold;

  static const codeInlineRatio = 0.88;
  static const codeLabelRatio = 0.8;
  static const scaleUnit = 1.0;
  static const readerBase = readerMedium;

  static const alphaHover = 0.04;
  static const alphaFocus = 0.08;
  static const alphaShadowSoft = 0.18;
  static const alphaShadowStrong = 0.4;
  static const alphaLineMax = 0.5;
  static const alphaZero = 0.0;

  static const glowBlur = 20.0;
  static const glowSpread = 2.0;
  static const liftBlur = 16.0;
  static const liftOffsetY = 4.0;
  static const hoverLift = -2.0;
  static const hoverNudge = 3.0;

  static const sidebarWidth = 300.0;
  static const headerHeight = 60.0;
  static const maxDocWidth = 1600.0;
  static const maxPageWidth = 1100.0;
  static const maxDialogWidth = 560.0;
  static const maxDialogHeight = 480.0;
  static const wideBreakpoint = 900.0;
  static const mediumBreakpoint = 600.0;
  static const pagePadWide = 100.0;
  static const pagePadMedium = 48.0;
  static const pagePadCompact = 16.0;
  static const docPadWide = 48.0;
  static const docPadCompact = 16.0;
  static const cardMinWidth = 300.0;
  static const cardMaxColumns = 10;
  static const cardGridGap = 10.0;
  static const cardAspectWide = 1.5;
  static const cardAspectCompact = 2.5;
  static const iconButton = 35.0;
  static const iconGlyph = 24.0;
  static const iconSmall = 15.0;
  static const iconTiny = 13.0;
  static const iconMedium = 16.0;
  static const iconSearch = 18.0;
  static const cursorHeight = 20.0;
  static const iconLarge = 22.0;
  static const appIcon = 32.0;
  static const appIconCache = 64;
  static const toggleCellWidth = 30.0;
  static const toggleCellHeight = 40.0;
  static const accentBar = 2.0;
  static const quoteBar = 3.0;
  static const sidebarIndent = 30.0;
  static const rulerHeight = 1.0;
  static const minTapTarget = 48.0;
  static const doubleRadiusFactor = 2.0;

  static const tableMinColumn = 120.0;
  static const fitSteps = 6;
  static const maxLinesCard = 3;
  static const noLines = 0;
  static const firstColumn = 1;
  static const maxLinesOne = 1;
  static const maxLinesTwo = 2;

  static const particlesHomeWide = 60;
  static const particlesHomeMedium = 45;
  static const particlesHomeCompact = 30;
  static const particlesDocWide = 40;
  static const particlesDocCompact = 20;
  static const particleMaxSpeed = 12.0;
  static const particleLinkDistance = 120.0;
  static const particleDotRadius = 1.6;
  static const particleLineWidth = 0.6;
  static const particleMaxDelta = 0.25;
  static const microsPerSecond = 1e6;
  static const halfTurn = 0.5;

  static const linkMatchThreshold = 0.5;

  static const snippetContext = 30;

  static const tabWidth = 4;

  static const indentPerLevel = 2;

  static const listMarkerEm = 1.6;

  static const firstIndex = 0;

  static const reveal = Duration(milliseconds: 520);
  static const stagger = Duration(milliseconds: 55);
  static const pageIn = Duration(milliseconds: 380);
  static const curveOut = Curves.easeOutCubic;
  static const curveSpring = Curves.easeOutBack;
  static const fast = Duration(milliseconds: 150);
  static const med = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 400);
  static const hover = Duration(milliseconds: 200);
  static const toast = Duration(seconds: 2);
  static const curve = Curves.fastOutSlowIn;
  static const curveHover = Curves.easeOut;

  static const sans = 'Space Grotesk';
  static const mono = 'JetBrains Mono';

  static const appTitle = 'psdkjoon docs';
  static const brandName = 'psdkjoon Docs';
  static const authorName = 'Hossein';
  static const iconAsset = 'assets/images/icon-192.webp';
}

/// Colors for syntax highlighting. Kept separate from [ColorScheme] so every
/// token kind gets its own hue (comments in particular no longer share a
/// color with plain text or borders).
@immutable
class SyntaxColors extends ThemeExtension<SyntaxColors> {
  final Color plain;
  final Color keyword;
  final Color string;
  final Color escape;
  final Color interpolation;
  final Color comment;
  final Color docComment;
  final Color number;
  final Color type;
  final Color function;
  final Color annotation;
  final Color op;
  final Color punctuation;
  final Color property;
  final Color constant;
  final Color variable;
  final Color flag;
  final Color lineNumber;
  final Color selection;

  const SyntaxColors({
    required this.plain,
    required this.keyword,
    required this.string,
    required this.escape,
    required this.interpolation,
    required this.comment,
    required this.docComment,
    required this.number,
    required this.type,
    required this.function,
    required this.annotation,
    required this.op,
    required this.punctuation,
    required this.property,
    required this.constant,
    required this.variable,
    required this.flag,
    required this.lineNumber,
    required this.selection,
  });

  static const dark = SyntaxColors(
    plain: Color(0xFFE9DFC8),
    keyword: Color(0xFFE5789A),
    string: Color(0xFFA3CC7A),
    escape: Color(0xFF4EC9D4),
    interpolation: Color(0xFFF2B5A0),
    comment: Color(0xFF74839A),
    docComment: Color(0xFF86A9A0),
    number: Color(0xFFF4A261),
    type: Color(0xFF6CB6F0),
    function: Color(0xFFE9C46A),
    annotation: Color(0xFFB49AF0),
    op: Color(0xFFD4B896),
    punctuation: Color(0xFF9A8C70),
    property: Color(0xFF8BD3C0),
    constant: Color(0xFFD58FE8),
    variable: Color(0xFFFFA8A8),
    flag: Color(0xFF9ED0FF),
    lineNumber: Color(0xFF5C5138),
    selection: Color(0x33D4A857),
  );

  static const light = SyntaxColors(
    plain: Color(0xFF2B2417),
    keyword: Color(0xFFB3365A),
    string: Color(0xFF4C7A1E),
    escape: Color(0xFF0C7F8C),
    interpolation: Color(0xFFB5532F),
    comment: Color(0xFF5F728C),
    docComment: Color(0xFF4E7F70),
    number: Color(0xFFB65A0F),
    type: Color(0xFF1F6FB5),
    function: Color(0xFF8F6A00),
    annotation: Color(0xFF6B4CC4),
    op: Color(0xFF7A5C36),
    punctuation: Color(0xFF8A7650),
    property: Color(0xFF1B8068),
    constant: Color(0xFFA2349F),
    variable: Color(0xFFB8403C),
    flag: Color(0xFF2C73B8),
    lineNumber: Color(0xFFB09C74),
    selection: Color(0x339C6B2E),
  );

  @override
  SyntaxColors copyWith({
    Color? plain,
    Color? keyword,
    Color? string,
    Color? escape,
    Color? interpolation,
    Color? comment,
    Color? docComment,
    Color? number,
    Color? type,
    Color? function,
    Color? annotation,
    Color? op,
    Color? punctuation,
    Color? property,
    Color? constant,
    Color? variable,
    Color? flag,
    Color? lineNumber,
    Color? selection,
  }) {
    return SyntaxColors(
      plain: plain ?? this.plain,
      keyword: keyword ?? this.keyword,
      string: string ?? this.string,
      escape: escape ?? this.escape,
      interpolation: interpolation ?? this.interpolation,
      comment: comment ?? this.comment,
      docComment: docComment ?? this.docComment,
      number: number ?? this.number,
      type: type ?? this.type,
      function: function ?? this.function,
      annotation: annotation ?? this.annotation,
      op: op ?? this.op,
      punctuation: punctuation ?? this.punctuation,
      property: property ?? this.property,
      constant: constant ?? this.constant,
      variable: variable ?? this.variable,
      flag: flag ?? this.flag,
      lineNumber: lineNumber ?? this.lineNumber,
      selection: selection ?? this.selection,
    );
  }

  @override
  SyntaxColors lerp(ThemeExtension<SyntaxColors>? other, double t) {
    if (other is! SyntaxColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return SyntaxColors(
      plain: mix(plain, other.plain),
      keyword: mix(keyword, other.keyword),
      string: mix(string, other.string),
      escape: mix(escape, other.escape),
      interpolation: mix(interpolation, other.interpolation),
      comment: mix(comment, other.comment),
      docComment: mix(docComment, other.docComment),
      number: mix(number, other.number),
      type: mix(type, other.type),
      function: mix(function, other.function),
      annotation: mix(annotation, other.annotation),
      op: mix(op, other.op),
      punctuation: mix(punctuation, other.punctuation),
      property: mix(property, other.property),
      constant: mix(constant, other.constant),
      variable: mix(variable, other.variable),
      flag: mix(flag, other.flag),
      lineNumber: mix(lineNumber, other.lineNumber),
      selection: mix(selection, other.selection),
    );
  }
}

extension DocThemeX on BuildContext {
  /// The raw palette (code background, etc.) for the active brightness.
  DocValues get docColors => Theme.of(this).brightness == Brightness.dark
      ? DocValues.dark
      : DocValues.light;

  SyntaxColors get syntax =>
      Theme.of(this).extension<SyntaxColors>() ?? SyntaxColors.dark;
}

ColorScheme _buildScheme(Brightness brightness, DocValues c) {
  return ColorScheme(
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
    onPrimary: c.onAccent,
    primaryContainer: c.accentStrong,
    onPrimaryContainer: c.onAccent,
    secondary: c.accent2,
    onSecondary: c.onAccent,
    tertiary: c.accentStrong,
    onTertiary: c.onAccent,
    outline: c.borderStrong,
    outlineVariant: c.border,
    shadow: DocValues.shadowColor,
    scrim: DocValues.shadowColor,
    inverseSurface: c.text,
    onInverseSurface: c.bg,
    inversePrimary: c.accentStrong,
    error: c.accent2,
    onError: c.onAccent,
  );
}

TextStyle _style({
  required double size,
  required FontWeight weight,
  required Color color,
  double? height,
  double? letterSpacing,
  String family = DocValues.sans,
}) {
  return TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
  );
}

ThemeData _buildTheme(
  Brightness brightness,
  DocValues c,
  SyntaxColors syntax,
) {
  return ThemeData(
    brightness: brightness,
    extensions: [syntax],
    colorScheme: _buildScheme(brightness, c),
    scaffoldBackgroundColor: c.bg,
    fontFamily: DocValues.sans,
    splashFactory: NoSplash.splashFactory,
    highlightColor: DocValues.transparent,
    dividerColor: c.border,
    cardTheme: CardThemeData(
      color: c.cardBg,
      surfaceTintColor: DocValues.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DocValues.sm),
        side: BorderSide(color: c.border),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: c.border,
      thickness: DocValues.borderThin,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.heading,
      elevation: DocValues.s0,
      scrolledUnderElevation: DocValues.s0,
      surfaceTintColor: DocValues.transparent,
      titleTextStyle: _style(
        size: DocValues.fsAppBar,
        weight: DocValues.fwBold,
        color: c.heading,
      ),
      iconTheme: IconThemeData(color: c.textMuted),
    ),
    textTheme: TextTheme(
      bodyLarge: _style(
        size: DocValues.fsBodyLg,
        weight: DocValues.fwMedium,
        height: DocValues.lhLoose,
        color: c.text,
      ),
      bodyMedium: _style(
        size: DocValues.fsBody,
        weight: DocValues.fwMedium,
        height: DocValues.lhBody,
        color: c.text,
      ),
      bodySmall: _style(
        size: DocValues.fsSmall,
        weight: DocValues.fwMedium,
        height: DocValues.lhRelaxed,
        color: c.textMuted,
      ),
      headlineLarge: _style(
        size: DocValues.fsHeadLg,
        weight: DocValues.fwBold,
        height: DocValues.lhTight,
        letterSpacing: DocValues.lsWide,
        color: c.heading,
      ),
      headlineMedium: _style(
        size: DocValues.fsHeadMd,
        weight: DocValues.fwBold,
        height: DocValues.lhTight,
        letterSpacing: DocValues.lsHead,
        color: c.heading,
      ),
      headlineSmall: _style(
        size: DocValues.fsHeadSm,
        weight: DocValues.fwBold,
        height: DocValues.lhTight,
        letterSpacing: DocValues.lsTight,
        color: c.heading,
      ),
      titleMedium: _style(
        size: DocValues.fsTitleSm,
        weight: DocValues.fwBold,
        height: DocValues.lhSnug,
        color: c.heading,
      ),
      labelLarge: _style(
        size: DocValues.fsBody2,
        weight: DocValues.fwSemi,
        color: c.text,
      ),
      labelMedium: _style(
        size: DocValues.fsSmall,
        weight: DocValues.fwSemi,
        color: c.textMuted,
      ),
      labelSmall: _style(
        size: DocValues.fsCaption,
        weight: DocValues.fwMedium,
        color: c.textFaint,
        family: DocValues.mono,
      ),
    ),
  );
}

final ThemeData lightTheme = _buildTheme(
  Brightness.light,
  DocValues.light,
  SyntaxColors.light,
);
final ThemeData darkTheme = _buildTheme(
  Brightness.dark,
  DocValues.dark,
  SyntaxColors.dark,
);
