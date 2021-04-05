import 'package:flutter/material.dart' show Color, ThemeData;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

abstract class IAppTheme {
  IAppTheme(this.materialTheme, this.defaultSystemOverlayStyle, this.sky, this.skyHighlight, this.shimmerBase,
      this.shimmerHighlight, this.cloud);

  final ThemeData materialTheme;
  final SystemUiOverlayStyle defaultSystemOverlayStyle;

  final shimmerBase;
  final shimmerHighlight;

  final Color cloud;
  final Color sky;
  final Color skyHighlight;
}
