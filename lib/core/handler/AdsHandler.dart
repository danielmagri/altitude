import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsHandler {
  static String get habitDetailsbannerAdUnitId => 'ca-app-pub-4496000445589212/7843041207';

  static AdRequest get adRequest => kReleaseMode ? AdRequest() : AdRequest(testDevices: ["E5BCE9B277498E2110B5F4F43C1A0E6C"]);
}
