import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'app_logic.g.dart';

@singleton
class AppLogic = _AppLogicBase with _$AppLogic;

abstract class _AppLogicBase with Store {

  SystemUiOverlayStyle _defaultStyle = SystemUiOverlayStyle();

  SystemUiOverlayStyle _lastStyle;

  void setDefaultStyle(SystemUiOverlayStyle value) {
    _defaultStyle = value;
    changeSystemStyle();
  }

  void changeSystemStyle({SystemUiOverlayStyle style}) {
    if (style == null) {
      style = _defaultStyle;
    }
    _lastStyle = style;
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  void updateSystemStyle() {
    SystemChrome.setSystemUIOverlayStyle(_lastStyle);
  }
}
