import 'package:flutter/material.dart';
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}


/// =======================
/// COLOR TOKENS
/// =======================
class AppColors {
  // Brand colors (Primary)
  // PFT: color.primary.default / light / dark :contentReference[oaicite:1]{index=1}
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFFEEF5FF);
  static const Color primaryDark = Color(0xFF0F4FB8);

  // Secondary
  static const Color secondary = Color(0xFFFF8A00);
  static const Color secondaryLight = Color(0xFFFFF3E6);
  static const Color secondaryDark = Color(0xFFCC6F00);

  // Neutral scale
  static const Color neutral900 = Color(0xFF212121);
  static const Color neutral800 = Color(0xFF303030);
  static const Color neutral700 = Color(0xFF424242);
  static const Color neutral600 = Color(0xFF616161);
  static const Color neutral500 = Color(0xFF757575);
  static const Color neutral400 = Color(0xFF9E9E9E);
  static const Color neutral300 = Color(0xFFBDBDBD);
  static const Color neutral200 = Color(0xFFE0E0E0);
  static const Color neutral100 = Color(0xFFEFEFEF);
  static const Color neutral50 = Color(0xFFF7F7F7);

  static const Color white = Colors.white;

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF0288D1);
}

/// =======================
/// TYPOGRAPHY TOKENS
/// =======================
/// Theo PFT typography: display, headline, title, body-lg, body, caption :contentReference[oaicite:2]{index=2}
class AppTextStyles {
  static const String _fontFamily = 'Inter'; // hoặc Roboto/RobotoFlex nếu bạn setup

  static TextStyle get display => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.neutral900,
      );

  static TextStyle get headline => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.neutral900,
      );

  static TextStyle get title => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.neutral900,
      );

  static TextStyle get bodyLg => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.neutral900,
      );

  static TextStyle get body => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.neutral900,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: AppColors.neutral600,
      );
}

/// =======================
/// SPACING / RADIUS / SHADOW
/// =======================

class AppRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(20));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(100));
}

class AppShadows {
  // shadow.level1: blur 4, opacity 8%
  static List<BoxShadow> level1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // shadow.level2: blur 12, opacity 12%
  static List<BoxShadow> level2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // shadow.level3: blur 20, opacity 16%
  static List<BoxShadow> level3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

/// =======================
/// THEME DATA (LIGHT / DARK)
/// =======================
class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: false);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.primary,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.white,
        background: AppColors.white,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: AppTextStyles.display,
        headlineMedium: AppTextStyles.headline,
        titleMedium: AppTextStyles.title,
        bodyLarge: AppTextStyles.bodyLg,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral900,
        ),
        iconTheme: IconThemeData(color: AppColors.neutral900),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.medium,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral50,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: AppColors.neutral200),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.neutral400),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.large,
          side: const BorderSide(color: AppColors.neutral200),
        ),
        shadowColor: Colors.black.withOpacity(0.12),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: false);

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: AppColors.primary,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: const Color(0xFF1D1D1D),
        background: const Color(0xFF121212),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: AppColors.neutral100,
        displayColor: AppColors.neutral100,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral100,
        ),
        iconTheme: IconThemeData(color: AppColors.neutral100),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1D1D1D),
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: const BorderSide(color: AppColors.neutral600),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: AppColors.neutral600),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.neutral400),
      ),
    );
  }
}
