import 'dart:ui';

import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter/material.dart' show Brightness, Colors, TextStyle, TextTheme, ThemeData;
import 'package:flutter/services.dart' show Brightness, SystemUiOverlayStyle;
import 'interface/app_theme_interface.dart';

class DarkTheme implements IAppTheme {
  @override
  final ThemeData materialTheme = ThemeData(
    fontFamily: 'Montserrat',
    accentColor: AppColors.colorDarkAccent,
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    backgroundColor: AppColors.colorDarkBackground,
    cardColor: AppColors.colorDarkAccent,
    scaffoldBackgroundColor: AppColors.colorDarkBackground,
    textTheme: const TextTheme(
      caption: TextStyle(fontFamily: 'Montserrat'),
      overline: TextStyle(fontFamily: 'Montserrat'),
      subtitle1: TextStyle(fontFamily: 'Montserrat'),
      subtitle2: TextStyle(fontFamily: 'Montserrat'),
      headline1: TextStyle(fontFamily: 'Montserrat'),
      headline2: TextStyle(fontFamily: 'Montserrat'),
      headline3: TextStyle(fontFamily: 'Montserrat'),
      headline4: TextStyle(fontFamily: 'Montserrat'),
      headline5: TextStyle(fontFamily: 'Montserrat'),
      headline6: TextStyle(fontFamily: 'Montserrat'),
      bodyText1: TextStyle(fontFamily: 'Montserrat'),
      bodyText2: TextStyle(fontFamily: 'Montserrat'),
      button: TextStyle(fontFamily: 'Montserrat'),
    ),
  );

  @override
  SystemUiOverlayStyle get defaultSystemOverlayStyle => SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.colorDarkBackground,
      systemNavigationBarIconBrightness: Brightness.light);

  @override
  Color get cloud => AppColors.colorDarkCloud;

  @override
  Color get sky => AppColors.colorDarkSky;

  @override
  Color get skyHighlight => AppColors.colorDarkSkyHighlight;

  @override
  get shimmerBase => AppColors.colorDarkShimmerBase;

  @override
  get shimmerHighlight => AppColors.colorDarkShimmerHighlight;
}
