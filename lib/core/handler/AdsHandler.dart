import 'package:flutter/foundation.dart';

abstract class AdsHandler {
  static const _ANDROID_BANNER_UNIT_ID_TEST = "ca-app-pub-3940256099942544/6300978111";

  static String get habitDetailsbannerAdUnitId =>
      kReleaseMode ? 'ca-app-pub-4496000445589212/7843041207' : _ANDROID_BANNER_UNIT_ID_TEST;
}
