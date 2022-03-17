import 'package:flutter/material.dart';

enum ThemeType { LIGHT, DARK, SYSTEM }

extension ThemeTypeExtension on ThemeType? {
  String get themeString {
    switch (this) {
      case ThemeType.LIGHT:
        return "light";
      case ThemeType.DARK:
        return "dark";
      case ThemeType.SYSTEM:
      default:
        return "system";
    }
  }

  String get themePrettyString {
    switch (this) {
      case ThemeType.LIGHT:
        return "Tema Claro";
      case ThemeType.DARK:
        return "Tema Escuro";
      case ThemeType.SYSTEM:
      default:
        return "Padrão do sistema";
    }
  }

  ThemeMode get toThemeMode {
    switch (this) {
      case ThemeType.LIGHT:
        return ThemeMode.light;
      case ThemeType.DARK:
        return ThemeMode.dark;
      case ThemeType.SYSTEM:
      default:
        return ThemeMode.system;
    }
  }
}

ThemeType getThemeType(String value) {
  switch (value) {
    case "light":
      return ThemeType.LIGHT;
    case "dark":
      return ThemeType.DARK;
    case "system":
    default:
      return ThemeType.SYSTEM;
  }
}
