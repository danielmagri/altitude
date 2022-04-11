import 'dart:ui';

import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/theme/interface/app_theme_interface.dart';
import 'package:flutter/material.dart'
    show
        AppBarTheme,
        BorderSide,
        Brightness,
        ChipThemeData,
        ColorScheme,
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

class DarkTheme implements IAppTheme {
  @override
  final ThemeData materialTheme = ThemeData(
    fontFamily: 'Montserrat',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      background: AppColors.colorDarkBackground,
      onBackground: Colors.white,
      secondary: AppColors.colorDarkAccent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.black,
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: AppColors.colorDarkAccent,
      onSurface: Colors.white,
    ),
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    backgroundColor: AppColors.colorDarkBackground,
    cardColor: AppColors.colorDarkAccent,
    scaffoldBackgroundColor: AppColors.colorDarkBackground,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorDarkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      elevation: 0,
      centerTitle: true,
      color: Colors.transparent,
      actionsIconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.white),
    ),
    chipTheme: ChipThemeData.fromDefaults(
      brightness: Brightness.dark,
      secondaryColor: Colors.black,
      labelStyle: const TextStyle(fontSize: 15),
    ),
    tabBarTheme: const TabBarTheme(
      indicator: ShapeDecoration(
        shape: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
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
  SystemUiOverlayStyle get defaultSystemOverlayStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorDarkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      );

  @override
  Color get cloud => AppColors.colorDarkCloud;

  @override
  Color get sky => AppColors.colorDarkSky;

  @override
  Color get skyHighlight => AppColors.colorDarkSkyHighlight;

  @override
  Color get shimmerBase => AppColors.colorDarkShimmerBase;

  @override
  Color get shimmerHighlight => AppColors.colorDarkShimmerHighlight;

  @override
  Color get disableHabitCreationCard => AppColors.colorDarkDisableHabitCreation;

  @override
  Color get chipSelected => AppColors.colorDarkChipSelected;

  @override
  Color get drawerIcon => AppColors.colorDarkDrawerIcon;

  @override
  Color get loading => AppColors.colorDarkLoading;

  @override
  Color get statisticLine => AppColors.colorDarkStatisticLine;

  @override
  Color get frequencyDot => AppColors.colorDarkFrequencyDot;

  @override
  Color get alarmUnselectedCard => AppColors.colorDarkAlarmUnselectedCard;

  @override
  Color get alarmUnselectedText => AppColors.colorDarkAlarmUnselectedText;
}
