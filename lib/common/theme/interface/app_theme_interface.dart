import 'package:flutter/material.dart' show Color, ThemeData;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

abstract class IAppTheme {
  IAppTheme(
    this.materialTheme,
    this.defaultSystemOverlayStyle,
    this.sky,
    this.skyHighlight,
    this.shimmerBase,
    this.shimmerHighlight,
    this.cloud,
    this.disableHabitCreationCard,
    this.chipSelected,
    this.drawerIcon,
    this.loading,
    this.statisticLine,
    this.frequencyDot,
    this.alarmUnselectedCard,
    this.alarmUnselectedText,
  );

  final ThemeData materialTheme;
  final SystemUiOverlayStyle defaultSystemOverlayStyle;

  final Color loading;

  final Color shimmerBase;
  final Color shimmerHighlight;

  final Color drawerIcon;

  final Color disableHabitCreationCard;
  final Color chipSelected;

  final Color cloud;
  final Color sky;
  final Color skyHighlight;

  final Color statisticLine;
  final Color frequencyDot;

  final Color alarmUnselectedCard;
  final Color alarmUnselectedText;
}
