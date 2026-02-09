import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// YouTube TV 风格主题配置
class AppTheme {
  AppTheme._();

  // 颜色定义 - YouTube TV 深色主题（更接近真实 YouTube TV）
  static const Color _primaryColor = Color(0xFFFFFFFF);
  static const Color _secondaryColor = Color(0xFF909090);
  static const Color _backgroundColor = Color(0xFF000000); // 纯黑背景
  static const Color _surfaceColor = Color(0xFF1A1A1A);
  static const Color _surfaceVariantColor = Color(0xFF2A2A2A);
  static const Color _cardColor = Color(0xFF212121);
  static const Color _errorColor = Color(0xFFFF3B3B);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFFC107);
  static const Color _infoColor = Color(0xFF2196F3);
  static const Color _accentColor = Color(0xFFFF0000); // YouTube 红色
  static const Color _focusColor = Color(0xFFFFFFFF); // 白色焦点边框
  static const Color _focusGlowColor = Color(0x33FFFFFF); // 焦点发光

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
        fontSize: 28,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: _primaryColor, size: 28),
      scrolledUnderElevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: _cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Colors.transparent, width: 0),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _surfaceVariantColor,
        foregroundColor: _primaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: _surfaceVariantColor, width: 2),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: _primaryColor,
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    iconTheme: const IconThemeData(color: _primaryColor, size: 28),
    textTheme: _textTheme,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _surfaceColor.withValues(alpha: 0.95),
      elevation: 0,
      height: 80,
      indicatorColor: _focusColor.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: _primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          );
        }
        return const TextStyle(color: _secondaryColor, fontSize: 14);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _primaryColor, size: 32);
        }
        return const IconThemeData(color: _secondaryColor, size: 28);
      }),
    ),
    focusColor: _focusGlowColor,
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
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _focusColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(color: _secondaryColor, fontSize: 16),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: _surfaceVariantColor,
      selectedColor: _accentColor,
      labelStyle: TextStyle(color: _primaryColor, fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      side: BorderSide.none,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: _surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: TextStyle(color: _secondaryColor, fontSize: 16),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      elevation: 0,
    ),
  );

  static TextTheme get _textTheme => GoogleFonts.robotoTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(fontSize: 52, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontSize: 44, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
      headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    ),
  ).apply(bodyColor: _primaryColor, displayColor: _primaryColor);

  // 自定义颜色扩展
  static const Color accent = _accentColor;
  static const Color focus = _focusColor;
  static const Color focusGlow = _focusGlowColor;
  static const Color background = _backgroundColor;
  static const Color surface = _surfaceColor;
  static const Color surfaceVariant = _surfaceVariantColor;
  static const Color card = _cardColor;
  static const Color onBackground = _primaryColor;
  static const Color onSurface = _primaryColor;
  static const Color error = _errorColor;
  static const Color success = _successColor;
  static const Color warning = _warningColor;
  static const Color info = _infoColor;

  // UI 颜色别名
  static const Color darkBackground = _backgroundColor;
  static const Color darkSurface = _surfaceColor;
  static const Color darkCard = _cardColor;
  static const Color darkBorder = _surfaceVariantColor;
  static const Color primaryColor = _primaryColor;
  static const Color textPrimary = _primaryColor;
  static const Color textSecondary = _secondaryColor;
}
