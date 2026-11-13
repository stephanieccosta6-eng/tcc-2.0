import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Superfícies & Fundos
  static const Color background = Color(0xFFFAF7F5); // Creme off-white suave (menos cansativo)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFFFF1F2);

  // Paleta Primária (Rose Skincare Elegante)
  static const Color primary = Color(0xFFBE185D); // Rose 700 refinado
  static const Color primaryLight = Color(0xFFF43F5E);
  static const Color primarySoft = Color(0xFFFCE7F3);
  static const Color accentGold = Color(0xFFD97706);

  // GlowFridge IoT (Tons Frios Harmonizados)
  static const Color fridgeDark = Color(0xFF1E293B);
  static const Color fridgeDeep = Color(0xFF0F172A);
  static const Color iceAccent = Color(0xFF38BDF8);

  // Textos & Bordas
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderSubtle = Color(0xFFF1E8E6);
  static const Color success = Color(0xFF059669);
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseText = GoogleFonts.plusJakartaSansTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: baseText.copyWith(
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.2,
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          height: 1.45,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySoft,
        elevation: 3,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary);
          }
          return const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
        }),
      ),
    );
  }

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF881337).withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
