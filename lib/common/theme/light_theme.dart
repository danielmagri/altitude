import 'dart:ui';

import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter/material.dart'
    show
        AppBarTheme,
        BorderSide,
        Brightness,
        ChipThemeData,
        Colors,
        IconThemeData,
        MaterialStateProperty,
        RadioThemeData,
        ShapeDecoration,
        TabBarTheme,
        TextButton,
        TextButtonThemeData,
        TextStyle,
        TextTheme,
        ThemeData,
        UnderlineInputBorder;
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
    appBarTheme: const AppBarTheme(
      brightness: Brightness.light,
      elevation: 0,
      centerTitle: true,
      color: Colors.transparent,
      actionsIconTheme: const IconThemeData(color: Colors.black),
      textTheme:
          const TextTheme(headline6: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(Colors.black),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.black),
    ),
    chipTheme: ChipThemeData.fromDefaults(
      brightness: Brightness.light,
      secondaryColor: Colors.white,
      labelStyle: const TextStyle(fontSize: 15),
    ),
    tabBarTheme: TabBarTheme(
      indicator: ShapeDecoration(shape: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))),
      unselectedLabelColor: Colors.black,
      labelColor: Colors.black,
      unselectedLabelStyle: const TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
    ),
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
  Color get shimmerBase => AppColors.colorLightShimmerBase;

  @override
  Color get shimmerHighlight => AppColors.colorLightShimmerHighlight;

  @override
  Color get disableHabitCreationCard => AppColors.colorLightDisableHabitCreation;

  @override
  Color get chipSelected => AppColors.colorLightChipSelected;

  @override
  Color get drawerIcon => AppColors.colorLightDrawerIcon;

  @override
  Color get loading => AppColors.colorLightLoading;

  @override
  Color get statisticLine => AppColors.colorLightStatisticLine;

  @override
  Color get frequencyDot => AppColors.colorLightFrequencyDot;

  @override
  Color get alarmUnselectedCard => AppColors.colorLightAlarmUnselectedCard;

  @override
  Color get alarmUnselectedText => AppColors.colorLightAlarmUnselectedText;
}
