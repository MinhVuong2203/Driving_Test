import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // Brand / Primary
  // =========================
  static const primary = Color(0xFF0866FF);
  static const primaryDark = Color(0xFF0052CC);
  static const primaryLight = Color(0xFFE8F0FF);

  static const secondary = Color(0xFF6366F1);
  static const secondaryDark = Color(0xFF4F46E5);
  static const secondaryLight = Color(0xFFEEF2FF);

  // =========================
  // Common
  // =========================
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Colors.transparent;

  // =========================
  // Status
  // =========================
  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFFEAF7EE);
  static const successDark = Color(0xFF15803D);

  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFFF7E6);
  static const warningDark = Color(0xFFD97706);

  static const danger = Color(0xFFDC2626);
  static const dangerLight = Color(0xFFFFEAEA);
  static const dangerDark = Color(0xFFB91C1C);

  static const info = Color(0xFF0284C7);
  static const infoLight = Color(0xFFE6F6FF);
  static const infoDark = Color(0xFF0369A1);

  // =====================================================
  // LIGHT THEME COLORS
  // =====================================================

  // Background
  static const lightBackground = Color(0xFFF7F9FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const cardLight = Color.fromRGBO(219, 228, 255, 0.6);

  // Navigation
  static const navigationBarLight = Color.fromRGBO(219, 228, 255, 0.7);
  static const lightBottomNavSelected = primary;
  static const lightBottomNavUnselected = Color(0xFF8A8A8A);

  // Text
  static const lightTextPrimary = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightTextMuted = Color(0xFF9CA3AF);
  static const lightTextDisabled = Color(0xFFBDBDBD);
  static const lightTextOnPrimary = Color(0xFFFFFFFF);

  // Icon
  static const iconLight = Color(0xFF6B7280);
  static const lightIconActive = primary;
  static const lightIconDisabled = Color(0xFFC4C4C4);

  // Input
  static const lightInputBackground = Color(0xFFFFFFFF);
  static const lightInputText = Color(0xFF111827);
  static const lightInputHint = Color(0xFF9CA3AF);
  static const lightInputBorder = Color(0xFFD1D5DB);
  static const lightInputFocusedBorder = primary;
  static const lightInputErrorBorder = danger;
  static const lightInputDisabledBackground = Color(0xFFF3F4F6);
  static const lightInputDisabledText = Color(0xFF9CA3AF);

  // Select / Dropdown
  static const lightSelectBackground = Color(0xFFFFFFFF);
  static const lightSelectText = Color(0xFF111827);
  static const lightSelectHint = Color(0xFF9CA3AF);
  static const lightSelectBorder = Color(0xFFD1D5DB);
  static const lightSelectFocusedBorder = primary;
  static const lightSelectMenuBackground = Color(0xFFFFFFFF);
  static const lightSelectItemHover = Color(0xFFF3F6FF);

  // Button
  static const lightButtonPrimary = primary;
  static const lightButtonPrimaryText = Color(0xFFFFFFFF);
  static const lightButtonSecondary = Color(0xFFE8F0FF);
  static const lightButtonSecondaryText = primary;
  static const lightButtonOutlineBorder = primary;
  static const lightButtonDisabled = Color(0xFFE5E7EB);
  static const lightButtonDisabledText = Color(0xFF9CA3AF);

  // Border / Divider
  static const lightBorder = Color(0xFFE5E7EB);
  static const lightBorderStrong = Color(0xFFD1D5DB);
  static const lightDivider = Color(0xFFE5E7EB);

  // AppBar
  static const lightAppBarBackground = Color(0xFFFFFFFF);
  static const lightAppBarText = Color(0xFF111827);
  static const lightAppBarIcon = Color(0xFF111827);

  // Chip / Badge
  static const lightChipBackground = Color(0xFFE8F0FF);
  static const lightChipText = primary;
  static const lightBadgeBackground = danger;
  static const lightBadgeText = Color(0xFFFFFFFF);

  // Overlay / Shadow / Shimmer
  static const lightOverlay = Color.fromRGBO(0, 0, 0, 0.35);
  static const lightShadow = Color.fromRGBO(0, 0, 0, 0.08);
  static const lightShimmerBase = Color(0xFFE5E7EB);
  static const lightShimmerHighlight = Color(0xFFF9FAFB);

  // =====================================================
  // DARK THEME COLORS
  // =====================================================

  // Background
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF181818);
  static const cardDark = Color(0xFF1E1E1E);

  // Navigation
  static const navigationBarDark = Color(0xFF2C2C2C);
  static const darkBottomNavSelected = primary;
  static const darkBottomNavUnselected = Color(0xFFB0B0B0);

  // Text
  static const darkTextPrimary = Color(0xFFF9FAFB);
  static const darkTextSecondary = Color(0xFFD1D5DB);
  static const darkTextMuted = Color(0xFF9CA3AF);
  static const darkTextDisabled = Color(0xFF6B7280);
  static const darkTextOnPrimary = Color(0xFFFFFFFF);

  // Icon
  static const iconDark = Color(0xFFE0E0E0);
  static const darkIconActive = primary;
  static const darkIconDisabled = Color(0xFF6B7280);

  // Input
  static const darkInputBackground = Color(0xFF242424);
  static const darkInputText = Color(0xFFF9FAFB);
  static const darkInputHint = Color(0xFF9CA3AF);
  static const darkInputBorder = Color(0xFF3A3A3A);
  static const darkInputFocusedBorder = primary;
  static const darkInputErrorBorder = danger;
  static const darkInputDisabledBackground = Color(0xFF1A1A1A);
  static const darkInputDisabledText = Color(0xFF6B7280);

  // Select / Dropdown
  static const darkSelectBackground = Color(0xFF242424);
  static const darkSelectText = Color(0xFFF9FAFB);
  static const darkSelectHint = Color(0xFF9CA3AF);
  static const darkSelectBorder = Color(0xFF3A3A3A);
  static const darkSelectFocusedBorder = primary;
  static const darkSelectMenuBackground = Color(0xFF2A2A2A);
  static const darkSelectItemHover = Color(0xFF1F2A44);

  // Button
  static const darkButtonPrimary = primary;
  static const darkButtonPrimaryText = Color(0xFFFFFFFF);
  static const darkButtonSecondary = Color(0xFF1F2A44);
  static const darkButtonSecondaryText = Color(0xFFBBD2FF);
  static const darkButtonOutlineBorder = primary;
  static const darkButtonDisabled = Color(0xFF333333);
  static const darkButtonDisabledText = Color(0xFF777777);

  // Border / Divider
  static const darkBorder = Color(0xFF333333);
  static const darkBorderStrong = Color(0xFF4B5563);
  static const darkDivider = Color(0xFF2F2F2F);

  // AppBar
  static const darkAppBarBackground = Color(0xFF181818);
  static const darkAppBarText = Color(0xFFF9FAFB);
  static const darkAppBarIcon = Color(0xFFF9FAFB);

  // Chip / Badge
  static const darkChipBackground = Color(0xFF1F2A44);
  static const darkChipText = Color(0xFFBBD2FF);
  static const darkBadgeBackground = danger;
  static const darkBadgeText = Color(0xFFFFFFFF);

  // Overlay / Shadow / Shimmer
  static const darkOverlay = Color.fromRGBO(0, 0, 0, 0.65);
  static const darkShadow = Color.fromRGBO(0, 0, 0, 0.35);
  static const darkShimmerBase = Color(0xFF2C2C2C);
  static const darkShimmerHighlight = Color(0xFF3A3A3A);
}