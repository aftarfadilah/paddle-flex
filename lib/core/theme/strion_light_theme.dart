import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart' show DarkColors, AppColors;

class LightColors {
  static const bg              = Color(0xFFF8F8FA);
  static const surface         = Color(0xFFFFFFFF);
  static const surfaceMid      = Color(0xFFF2F2F5);
  static const surfaceHigh     = Color(0xFFE8E8EE);
  static const accent          = Color(0xFF00B39A);
  static const accentDim       = Color(0xFF009A82);
  static const gold            = Color(0xFFD4AF37);
  static const goldLight       = Color(0xFFE8C547);
  static const textPrimary     = Color(0xFF1A1A2E);
  static const textSecondary   = Color(0xFF6B6B7A);
  static const textTertiary    = Color(0xFF9A9AAD);
  static const textDisabled    = Color(0xFFCCCCD8);
  static const border          = Color(0xFFE4E4EC);
  static const borderLight     = Color(0xFFF0F0F5);
  static const error           = Color(0xFFE53935);
  static const success         = Color(0xFF00B39A);
  static const warning         = Color(0xFFF59E0B);
  static const accentGradient  = LinearGradient(
    colors: [Color(0xFF00B39A), Color(0xFF009A82)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const goldGradient    = LinearGradient(
    colors: [Color(0xFFE8C547), Color(0xFFD4AF37)],
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
  );
}

class LightTheme {
  static const _displayFamily = 'Space Grotesk';
  static const _bodyFamily    = 'Inter';
  static const _monoFamily   = 'JetBrains Mono';

  static TextStyle _display([Color? c]) => TextStyle(
    fontFamily: _displayFamily, fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w700, letterSpacing: -0.5,
  ).copyWith(color: c ?? LightColors.textPrimary);

  static TextStyle _headline([Color? c]) => TextStyle(
    fontFamily: _displayFamily, fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w600, letterSpacing: -0.3,
  ).copyWith(color: c ?? LightColors.textPrimary);

  static TextStyle _title([Color? c]) => TextStyle(
    fontFamily: _displayFamily, fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w600,
  ).copyWith(color: c ?? LightColors.textPrimary);

  static TextStyle _body([Color? c]) => TextStyle(
    fontFamily: _bodyFamily, fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w400,
  ).copyWith(color: c ?? LightColors.textPrimary);

  static TextStyle _bodySmall([Color? c]) => TextStyle(
    fontFamily: _bodyFamily, fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w400,
  ).copyWith(color: c ?? LightColors.textSecondary);

  static TextStyle _mono([Color? c]) => TextStyle(
    fontFamily: _monoFamily, fontFamilyFallback: ['monospace'],
    fontWeight: FontWeight.w600,
  ).copyWith(color: c ?? LightColors.textPrimary);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.bg,
    colorScheme: const ColorScheme.light(
      primary: LightColors.accent,
      secondary: LightColors.gold,
      surface: LightColors.surface,
      error: LightColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: LightColors.textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge:  _display(LightColors.textPrimary).copyWith(fontSize: 32),
      displayMedium: _display(LightColors.textPrimary).copyWith(fontSize: 26),
      displaySmall:  _headline(LightColors.textPrimary).copyWith(fontSize: 20),
      headlineMedium: _headline(LightColors.textPrimary).copyWith(fontSize: 18),
      titleLarge:    _title(LightColors.textPrimary).copyWith(fontSize: 16),
      titleMedium:   _title(LightColors.textPrimary).copyWith(fontSize: 14),
      bodyLarge:     _body(LightColors.textPrimary).copyWith(fontSize: 16),
      bodyMedium:    _body(LightColors.textPrimary).copyWith(fontSize: 14),
      bodySmall:    _bodySmall(LightColors.textSecondary).copyWith(fontSize: 12),
      labelLarge:   _mono(LightColors.textPrimary).copyWith(fontSize: 14),
      labelMedium:  _mono(LightColors.textPrimary).copyWith(fontSize: 12),
      labelSmall:   _mono(LightColors.textPrimary).copyWith(fontSize: 10, letterSpacing: 1),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0, scrolledUnderElevation: 0, centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: LightColors.textPrimary),
      titleTextStyle: const TextStyle(
        fontFamily: _displayFamily, fontSize: 20,
        fontWeight: FontWeight.w700, letterSpacing: -0.3, color: LightColors.textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: LightColors.surface, elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: LightColors.border, width: 0.75),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColors.accent, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: _title().copyWith(fontWeight: FontWeight.w700),
        elevation: 2,
      ),
    ),
    dividerTheme: const DividerThemeData(color: LightColors.border, thickness: 0.75),
    tabBarTheme: TabBarThemeData(
      labelColor: LightColors.accent,
      unselectedLabelColor: LightColors.textSecondary,
      indicatorColor: LightColors.accent,
      dividerColor: Colors.transparent,
      labelStyle: _title().copyWith(fontSize: 13, fontWeight: FontWeight.w600),
      unselectedLabelStyle: _title().copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: LightColors.accent, width: 2.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
      ),
    ),
  );
}
