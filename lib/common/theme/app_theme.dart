import 'package:altitude/common/theme/dark_theme.dart';
import 'package:altitude/common/theme/interface/app_theme_interface.dart';
import 'package:altitude/common/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef Builder = Widget Function(ThemeMode themeMode);

class AppTheme extends StatefulWidget {
  const AppTheme({Key? key, this.builder, this.themeChanged, this.initialTheme})
      : super(key: key);

  final Builder? builder;
  final ThemeMode? initialTheme;
  final Function(IAppTheme theme)? themeChanged;

  static IAppTheme of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedThemeState>()!
        .state
        .theme;
  }

  static bool isDark(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedThemeState>()!
        .state
        .isDark;
  }

  static ThemeMode themeMode(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedThemeState>()!
        .mode;
  }

  static void changeTheme(BuildContext context, ThemeMode mode) {
    context
        .dependOnInheritedWidgetOfExactType<_InheritedThemeState>()!
        .state
        .changeTheme(mode);
  }

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
    widget.themeChanged!(theme);
    super.initState();
  }

  bool get isDark =>
      mode == ThemeMode.dark ||
      (mode == ThemeMode.system &&
          SchedulerBinding.instance!.window.platformBrightness ==
              Brightness.dark);

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
    widget.themeChanged!(theme);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeState(
      mode: mode,
      state: this,
      child: widget.builder!(mode),
    );
  }
}

class _InheritedThemeState extends InheritedWidget {
  const _InheritedThemeState({
    required this.mode,
    required this.state,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final ThemeMode mode;
  final _AppThemeState state;

  @override
  bool updateShouldNotify(_InheritedThemeState old) => mode != old.mode;
}
