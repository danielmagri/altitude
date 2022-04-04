import 'package:flutter/material.dart';

enum ThemeType { light, dark, system }

extension ThemeTypeExtension on ThemeType? {
  String get themeString {
    switch (this) {
      case ThemeType.light:
        return 'light';
      case ThemeType.dark:
        return 'dark';
      case ThemeType.system:
      default:
        return 'system';
    }
  }

  String get themePrettyString {
    switch (this) {
      case ThemeType.light:
        return 'Tema Claro';
      case ThemeType.dark:
        return 'Tema Escuro';
      case ThemeType.system:
      default:
        return 'Padrão do sistema';
    }
  }

  ThemeMode get toThemeMode {
    switch (this) {
      case ThemeType.light:
        return ThemeMode.light;
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.system:
      default:
        return ThemeMode.system;
    }
  }
}

ThemeType getThemeType(String value) {
  switch (value) {
    case 'light':
      return ThemeType.light;
    case 'dark':
      return ThemeType.dark;
    case 'system':
    default:
      return ThemeType.system;
  }
}
