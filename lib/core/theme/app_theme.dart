import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette
  static const primary = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFF6366F1);
  static const secondary = Color(0xFF06B6D4);
  static const dark = Color(0xFF1E1B4B);
  static const dark2 = Color(0xFF312E81);

  // Semantic
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const purple = Color(0xFF8B5CF6);

  // Neutrals
  static const white = Color(0xFFFFFFFF);
  static const offwhite = Color(0xFFF8F7FF);
  static const light = Color(0xFFEEF2FF);
  static const light2 = Color(0xFFE0E7FF);
  static const border = Color(0xFFC7D2FE);
  static const muted = Color(0xFF6B7280);
  static const textCol = Color(0xFF1F2937);

  // Surface
  static const surface = Color(0xFFF9FAFB);
  static const cardBg = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onPrimary: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.offwhite,
        textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
          displayLarge: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800, color: AppColors.dark),
          headlineLarge: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700, color: AppColors.dark),
          headlineMedium: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700, color: AppColors.dark),
          titleLarge: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600, color: AppColors.dark),
          titleMedium: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600, color: AppColors.dark),
          bodyLarge: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w400, color: AppColors.textCol),
          bodyMedium: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w400, color: AppColors.textCol),
          labelLarge: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppColors.border, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.dark,
          foregroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.light,
          selectedColor: AppColors.primary,
          labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13, fontWeight: FontWeight.w500),
          side: const BorderSide(color: AppColors.border),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      );
}
