import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'dark_theme.dart';
import 'interface/app_theme_interface.dart';
import 'light_theme.dart';

typedef Builder = Widget Function(ThemeMode themeMode);

class AppTheme extends StatefulWidget {
  final Builder builder;
  final ThemeMode initialTheme;
  final Function(IAppTheme theme) themeChanged;

  static IAppTheme of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedThemeState>()).state.theme;
  }

  static bool isDark(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedThemeState>()).state.isDark;
  }

  static ThemeMode themeMode(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedThemeState>()).mode;
  }

  static void changeTheme(BuildContext context, ThemeMode mode) {
    (context.dependOnInheritedWidgetOfExactType<_InheritedThemeState>()).state.changeTheme(mode);
  }

  const AppTheme({Key key, this.builder, this.themeChanged, this.initialTheme}) : super(key: key);

  @override
  _AppThemeState createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  ThemeMode mode = ThemeMode.system;

  IAppTheme lightTheme = LightTheme();
  IAppTheme darkTheme = DarkTheme();

  @override
  void initState() {
    mode = widget.initialTheme ?? ThemeMode.system;
    widget.themeChanged(theme);
    super.initState();
  }

  bool get isDark =>
      mode == ThemeMode.dark ||
      (mode == ThemeMode.system && SchedulerBinding.instance.window.platformBrightness == Brightness.dark);

  IAppTheme get theme {
    if (isDark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  void changeTheme(ThemeMode mode) {
    setState(() {
      this.mode = mode;
    });
    widget.themeChanged(theme);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeState(
      mode: mode,
      state: this,
      child: widget.builder(mode),
    );
  }
}

class _InheritedThemeState extends InheritedWidget {
  final ThemeMode mode;
  final _AppThemeState state;

  _InheritedThemeState({Key key, @required this.mode, @required this.state, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedThemeState old) => mode != old.mode;
}
