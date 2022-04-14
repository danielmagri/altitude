import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsHandler {
  static String get habitDetailsBannerAdUnitId => 'ca-app-pub-4496000445589212/7843041207';

  static String get statisticsBannerAdUnitId => 'ca-app-pub-4496000445589212/9371298187';

  static String get edithabitOnSaveIntersticialAdUnitId => 'ca-app-pub-4496000445589212/6118448880';
  static String get competitionOnCreateIntersticialAdUnitId => 'ca-app-pub-4496000445589212/6605534046';

  static AdRequest get adRequest =>
      kReleaseMode ? AdRequest() : AdRequest(testDevices: ["E5BCE9B277498E2110B5F4F43C1A0E6C"]);

  static AdListener get adListener => kReleaseMode
      ? AdListener(onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        })
      : AdListener(
          onAdLoaded: (Ad ad) => print('Ad loaded.'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) {
            ad.dispose();
            print('Ad closed.');
          },
          onApplicationExit: (Ad ad) => print('Left application.'),
        );
}
