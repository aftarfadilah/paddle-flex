import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32, fontWeight: FontWeight.bold, color: _textPrimary,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24, fontWeight: FontWeight.bold, color: _textPrimary,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 20, fontWeight: FontWeight.w600, color: _textPrimary,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimary,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(color: _textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: _textPrimary, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: _textSecondary, fontSize: 12),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary,
        ),
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
        hintStyle: GoogleFonts.inter(color: _textSecondary),
        labelStyle: GoogleFonts.inter(color: _textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 16),
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
        contentTextStyle: GoogleFonts.inter(color: _textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
