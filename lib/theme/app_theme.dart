import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color background;
  final Color surface;
  final Color cardBg;
  final Color cardBorder;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color accent;
  final Color textPrimary;
  final Color textDark;
  final Color textSecondary;
  final Color textMuted;
  final Color textLight;
  final Color successGreen;
  final Color errorRed;
  final Color warningYellow;
  final Color gold;
  final Color silver;
  final Color bronze;
  final Color starColor;
  final Color accentOrange;
  final Color accentPink;
  final Color scienceBadge;
  final Color techBadge;
  final Color engineerBadge;
  final Color artBadge;
  final Color mathBadge;
  final Color glass;
  final Color glassBorder;
  final Color overlay;

  const AppColorsExtension({
    required this.background, required this.surface, required this.cardBg,
    required this.cardBorder, required this.primary, required this.primaryLight,
    required this.primaryDark, required this.accent, required this.textPrimary,
    required this.textDark, required this.textSecondary, required this.textMuted,
    required this.textLight, required this.successGreen, required this.errorRed,
    required this.warningYellow, required this.gold, required this.silver,
    required this.bronze, required this.starColor, required this.accentOrange,
    required this.accentPink, required this.scienceBadge, required this.techBadge,
    required this.engineerBadge, required this.artBadge, required this.mathBadge,
    required this.glass, required this.glassBorder, required this.overlay,
  });

  @override
  AppColorsExtension copyWith({
    Color? background, Color? surface, Color? cardBg, Color? cardBorder,
    Color? primary, Color? primaryLight, Color? primaryDark, Color? accent,
    Color? textPrimary, Color? textDark, Color? textSecondary, Color? textMuted,
    Color? textLight, Color? successGreen, Color? errorRed, Color? warningYellow,
    Color? gold, Color? silver, Color? bronze, Color? starColor, Color? accentOrange,
    Color? accentPink, Color? scienceBadge, Color? techBadge, Color? engineerBadge,
    Color? artBadge, Color? mathBadge, Color? glass, Color? glassBorder, Color? overlay,
  }) => AppColorsExtension(
    background: background ?? this.background, surface: surface ?? this.surface,
    cardBg: cardBg ?? this.cardBg, cardBorder: cardBorder ?? this.cardBorder,
    primary: primary ?? this.primary, primaryLight: primaryLight ?? this.primaryLight,
    primaryDark: primaryDark ?? this.primaryDark, accent: accent ?? this.accent,
    textPrimary: textPrimary ?? this.textPrimary, textDark: textDark ?? this.textDark,
    textSecondary: textSecondary ?? this.textSecondary, textMuted: textMuted ?? this.textMuted,
    textLight: textLight ?? this.textLight, successGreen: successGreen ?? this.successGreen,
    errorRed: errorRed ?? this.errorRed, warningYellow: warningYellow ?? this.warningYellow,
    gold: gold ?? this.gold, silver: silver ?? this.silver, bronze: bronze ?? this.bronze,
    starColor: starColor ?? this.starColor, accentOrange: accentOrange ?? this.accentOrange,
    accentPink: accentPink ?? this.accentPink, scienceBadge: scienceBadge ?? this.scienceBadge,
    techBadge: techBadge ?? this.techBadge, engineerBadge: engineerBadge ?? this.engineerBadge,
    artBadge: artBadge ?? this.artBadge, mathBadge: mathBadge ?? this.mathBadge,
    glass: glass ?? this.glass, glassBorder: glassBorder ?? this.glassBorder,
    overlay: overlay ?? this.overlay,
  );

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
      warningYellow: Color.lerp(warningYellow, other.warningYellow, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      silver: Color.lerp(silver, other.silver, t)!,
      bronze: Color.lerp(bronze, other.bronze, t)!,
      starColor: Color.lerp(starColor, other.starColor, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentPink: Color.lerp(accentPink, other.accentPink, t)!,
      scienceBadge: Color.lerp(scienceBadge, other.scienceBadge, t)!,
      techBadge: Color.lerp(techBadge, other.techBadge, t)!,
      engineerBadge: Color.lerp(engineerBadge, other.engineerBadge, t)!,
      artBadge: Color.lerp(artBadge, other.artBadge, t)!,
      mathBadge: Color.lerp(mathBadge, other.mathBadge, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

extension AppThemeExtensionExt on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
}

class AppColors {
  static const primary = Color(0xFF22C55E);
  static const starColor = Color(0xFFFBBF24);
}

class AppTheme {
  static const _core = AppColorsExtension(
    background: Colors.transparent, surface: Colors.transparent,
    cardBg: Colors.transparent, cardBorder: Colors.transparent,
    primary: Color(0xFF22C55E), primaryLight: Color(0xFF4ADE80),
    primaryDark: Color(0xFF16A34A), accent: Color(0xFF22C55E),
    textPrimary: Colors.transparent, textDark: Colors.transparent,
    textSecondary: Colors.transparent, textMuted: Colors.transparent,
    textLight: Colors.transparent,
    successGreen: Color(0xFF22C55E), errorRed: Color(0xFFF43F5E),
    warningYellow: Color(0xFFFBBF24), gold: Color(0xFFF59E0B),
    silver: Color(0xFF94A3B8), bronze: Color(0xFFB45309),
    starColor: Color(0xFFFBBF24), accentOrange: Color(0xFFF97316),
    accentPink: Color(0xFFEC4899),
    scienceBadge: Color(0xFF14532D), techBadge: Color(0xFF1E3A5F),
    engineerBadge: Color(0xFF7C2D12), artBadge: Color(0xFF3B0764),
    mathBadge: Color(0xFF713F12),
    glass: Color(0x14FFFFFF), glassBorder: Color(0x22FFFFFF),
    overlay: Color(0x80000000),
  );

  // ── DARK: deep forest night ──
  static final _dark = _core.copyWith(
    background: const Color(0xFF0C0F0C),
    surface: const Color(0xFF141A14),
    cardBg: const Color(0xFF1C231C),
    cardBorder: const Color(0xFF263326),
    textPrimary: const Color(0xFFF0FDF4),
    textDark: const Color(0xFFFFFFFF),
    textSecondary: const Color(0xFF9DB89F),
    textMuted: const Color(0xFF607662),
    textLight: const Color(0xFF3A4A3B),
  );

  // ── LIGHT: bright botanical ──
  static final _light = _core.copyWith(
    background: const Color(0xFFF2FBF2),
    surface: const Color(0xFFFFFFFF),
    cardBg: const Color(0xFFFFFFFF),
    cardBorder: const Color(0xFFD8EED8),
    primary: const Color(0xFF16A34A),
    primaryLight: const Color(0xFF22C55E),
    primaryDark: const Color(0xFF15803D),
    accent: const Color(0xFF16A34A),
    textPrimary: const Color(0xFF0D1F0E),
    textDark: const Color(0xFF030A03),
    textSecondary: const Color(0xFF2F5C32),
    textMuted: const Color(0xFF527A55),
    textLight: const Color(0xFF88AA8A),
    successGreen: const Color(0xFF16A34A),
    errorRed: const Color(0xFFE11D48),
    warningYellow: const Color(0xFFD97706),
    gold: const Color(0xFFD97706),
    silver: const Color(0xFF64748B),
    bronze: const Color(0xFF92400E),
    starColor: const Color(0xFFD97706),
    accentOrange: const Color(0xFFEA580C),
    accentPink: const Color(0xFFDB2777),
    scienceBadge: const Color(0xFF14532D),
    techBadge: const Color(0xFF1D4ED8),
    engineerBadge: const Color(0xFFC2410C),
    artBadge: const Color(0xFF6D28D9),
    mathBadge: const Color(0xFFB45309),
    glass: const Color(0x060D1F0E),
    glassBorder: const Color(0x140D1F0E),
    overlay: const Color(0x4D0D1F0E),
  );

  static ThemeData get darkTheme => _build(Brightness.dark, _dark);
  static ThemeData get lightTheme => _build(Brightness.light, _light);

  static ThemeData _build(Brightness b, AppColorsExtension c) {
    final isDark = b == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      extensions: [c],
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary, brightness: b,
        primary: c.primary, surface: c.surface, error: c.errorRed,
      ),
      scaffoldBackgroundColor: c.background,
      textTheme: GoogleFonts.nunitoTextTheme(
        ThemeData(brightness: b).textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w800, color: c.textPrimary, letterSpacing: -0.5),
        displayMedium: GoogleFonts.sora(fontSize: 26, fontWeight: FontWeight.w700, color: c.textPrimary, letterSpacing: -0.3),
        displaySmall: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: c.textPrimary),
        titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary, letterSpacing: -0.2),
        titleMedium: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: c.textPrimary),
        bodyLarge: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w500, color: c.textPrimary, height: 1.6),
        bodyMedium: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w400, color: c.textMuted, height: 1.5),
        labelLarge: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700, color: c.primary, letterSpacing: 0.4),
        labelSmall: GoogleFonts.sora(fontSize: 9, fontWeight: FontWeight.w700, color: c.textMuted, letterSpacing: 0.6),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background, elevation: 0, centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w800, color: c.textPrimary, letterSpacing: -0.3),
        iconTheme: IconThemeData(color: c.textSecondary, size: 22),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary, foregroundColor: Colors.white,
          elevation: isDark ? 0 : 3,
          shadowColor: c.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          side: BorderSide(color: c.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? c.cardBg : c.primary.withValues(alpha: 0.04),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.cardBorder, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.cardBorder, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.errorRed, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle: GoogleFonts.nunito(color: c.textMuted, fontWeight: FontWeight.w600),
        hintStyle: GoogleFonts.nunito(color: c.textLight, fontWeight: FontWeight.w500),
        prefixIconColor: c.textMuted, suffixIconColor: c.textMuted,
      ),
      cardTheme: CardThemeData(
        color: c.cardBg, elevation: isDark ? 0 : 1,
        shadowColor: c.primary.withValues(alpha: isDark ? 0 : 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.cardBorder, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.cardBg,
        contentTextStyle: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : Colors.transparent),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: c.textLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      dividerTheme: DividerThemeData(color: c.cardBorder, thickness: 1, space: 1),
    );
  }
}
