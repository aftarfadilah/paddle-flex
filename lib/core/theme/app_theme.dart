import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const _bg = Color(0xFF0D0D0F);
  static const _surface = Color(0xFF1A1A1F);
  static const _surfaceRaised = Color(0xFF252530);
  static const _primary = Color(0xFF00D4AA);
  static const _accent = Color(0xFFFF6B35);
  static const _warning = Color(0xFFFFD60A);
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF8E8E9A);
  static const _border = Color(0xFF2E2E3A);
  static const _error = Color(0xFFFF453A);

  static Color get primary => _primary;
  static Color get accent => _accent;
  static Color get warning => _warning;
  static Color get error => _error;
  static Color get surface => _surface;
  static Color get surfaceRaised => _surfaceRaised;
  static Color get bg => _bg;
  static Color get border => _border;
  static Color get textSecondary => _textSecondary;

  // Base text styles using fontFamily (fonts loaded via Google Fonts CDN in index.html)
  static TextStyle get _inter => const TextStyle(fontFamily: 'Inter', fontFamilyFallback: ['sans-serif']);
  static TextStyle get _spaceGrotesk => const TextStyle(fontFamily: 'Space Grotesk', fontFamilyFallback: ['sans-serif']);
  static TextStyle get _mono => const TextStyle(fontFamily: 'JetBrains Mono', fontFamilyFallback: ['monospace']);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _bg,
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        secondary: _accent,
        surface: _surface,
        error: _error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: _textPrimary,
        onError: Colors.white,
      ),
      textTheme: ThemeData.dark().textTheme.copyWith(
        displayLarge: _spaceGrotesk.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: _textPrimary),
        displayMedium: _spaceGrotesk.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: _textPrimary),
        displaySmall: _spaceGrotesk.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: _textPrimary),
        headlineMedium: _spaceGrotesk.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimary),
        titleLarge: _spaceGrotesk.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary),
        bodyLarge: _inter.copyWith(fontSize: 16, color: _textPrimary),
        bodyMedium: _inter.copyWith(fontSize: 14, color: _textPrimary),
        bodySmall: _inter.copyWith(fontSize: 12, color: _textSecondary),
        labelLarge: _mono.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: _textPrimary),
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: _border)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        hintStyle: _inter.copyWith(color: _textSecondary),
        labelStyle: _inter.copyWith(color: _textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: _spaceGrotesk.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textPrimary,
          side: const BorderSide(color: _border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surface,
        selectedItemColor: _primary,
        unselectedItemColor: _textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: _border, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceRaised,
        contentTextStyle: _inter.copyWith(color: _textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
