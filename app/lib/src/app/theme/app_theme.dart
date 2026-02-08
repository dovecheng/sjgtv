import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// YouTube TV 风格主题配置
class AppTheme {
  AppTheme._();

  // 颜色定义 - YouTube TV 深色主题
  static const Color _primaryColor = Color(0xFFFFFFFF);
  static const Color _secondaryColor = Color(0xFFAAAAAA);
  static const Color _backgroundColor = Color(0xFF0F0F0F);
  static const Color _surfaceColor = Color(0xFF1F1F1F);
  static const Color _surfaceVariantColor = Color(0xFF282828);
  static const Color _errorColor = Color(0xFFFF3B3B);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFFC107);
  static const Color _infoColor = Color(0xFF2196F3);
  static const Color _accentColor = Color(0xFFCC0000); // YouTube Red
  static const Color _focusColor = Color(0xFF3EA6FF);

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accentColor,
          brightness: Brightness.dark,
          primary: _primaryColor,
          secondary: _secondaryColor,
          surface: _surfaceColor,
          surfaceContainer: _surfaceVariantColor,
          error: _errorColor,
          outline: _secondaryColor,
          outlineVariant: _surfaceVariantColor,
        ),
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: _primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: _primaryColor),
          scrolledUnderElevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: _surfaceColor,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: _surfaceVariantColor,
              width: 1,
            ),
          ),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _surfaceVariantColor,
            foregroundColor: _primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(
              color: _secondaryColor,
              width: 1.5,
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: _primaryColor,
            padding: const EdgeInsets.all(12),
            backgroundColor: _surfaceVariantColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _focusColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: _primaryColor,
          size: 24,
        ),
        textTheme: _textTheme,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: _surfaceColor.withValues(alpha: 0.95),
          elevation: 0,
          height: 80,
          indicatorColor: _focusColor.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: _focusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(
              color: _secondaryColor,
              fontSize: 12,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: _focusColor,
                size: 28,
              );
            }
            return const IconThemeData(
              color: _secondaryColor,
              size: 24,
            );
          }),
        ),
        focusColor: _focusColor.withValues(alpha: 0.3),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: _surfaceVariantColor,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surfaceVariantColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _focusColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _errorColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _errorColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: const TextStyle(
            color: _secondaryColor,
            fontSize: 14,
          ),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: _surfaceVariantColor,
          selectedColor: _focusColor,
          labelStyle: TextStyle(
            color: _primaryColor,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          side: BorderSide.none,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: _surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 8,
          titleTextStyle: TextStyle(
            color: _primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          contentTextStyle: TextStyle(
            color: _secondaryColor,
            fontSize: 14,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: _surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          elevation: 8,
        ),
      );

  static TextTheme get _textTheme => GoogleFonts.robotoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w400,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ).apply(
        bodyColor: _primaryColor,
        displayColor: _primaryColor,
      );

  // 自定义颜色扩展
  static const Color accent = _accentColor;
  static const Color focus = _focusColor;
  static const Color background = _backgroundColor;
  static const Color surface = _surfaceColor;
  static const Color surfaceVariant = _surfaceVariantColor;
  static const Color onBackground = _primaryColor;
  static const Color onSurface = _primaryColor;
  static const Color error = _errorColor;
  static const Color success = _successColor;
  static const Color warning = _warningColor;
  static const Color info = _infoColor;

  // UI 颜色别名
  static const Color darkBackground = _backgroundColor;
  static const Color darkSurface = _surfaceColor;
  static const Color darkCard = _surfaceColor;
  static const Color darkBorder = _surfaceVariantColor;
  static const Color primaryColor = _primaryColor;
  static const Color textPrimary = _primaryColor;
  static const Color textSecondary = _secondaryColor;
}