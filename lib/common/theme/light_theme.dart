import 'dart:ui';

import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter/material.dart' show Brightness, Colors, TextStyle, TextTheme, ThemeData;
import 'package:flutter/services.dart' show Brightness, SystemUiOverlayStyle;
import 'interface/app_theme_interface.dart';

class LightTheme implements IAppTheme {
  @override
  final ThemeData materialTheme = ThemeData(
    fontFamily: 'Montserrat',
    accentColor: AppColors.colorLightAccent,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: AppColors.colorLightBackground,
    cardColor: Colors.white,
    scaffoldBackgroundColor: AppColors.colorLightBackground,
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
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.colorLightBackground,
      systemNavigationBarIconBrightness: Brightness.dark);

  @override
  Color get cloud => AppColors.colorLightCloud;

  @override
  Color get sky => AppColors.colorLightSky;

  @override
  Color get skyHighlight => AppColors.colorLightSkyHighlight;

  @override
  get shimmerBase => AppColors.colorLightShimmerBase;

  @override
  get shimmerHighlight => AppColors.colorLightShimmerHighlight;
}
