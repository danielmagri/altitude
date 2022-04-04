import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsUtils {
  static String get habitDetailsBannerAdUnitId =>
      'ca-app-pub-4496000445589212/7843041207';

  static String get statisticsBannerAdUnitId =>
      'ca-app-pub-4496000445589212/9371298187';

  static String get edithabitOnSaveIntersticialAdUnitId =>
      'ca-app-pub-4496000445589212/6118448880';
  static String get competitionOnCreateIntersticialAdUnitId =>
      'ca-app-pub-4496000445589212/6605534046';

  static AdRequest get adRequest => const AdRequest();

  static NativeAdListener get adNativeListener => kReleaseMode
      ? NativeAdListener(
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        )
      : NativeAdListener(
          onAdLoaded: (ad) => print('Ad loaded.'),
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          onAdOpened: (ad) => print('Ad opened.'),
          onAdClosed: (ad) {
            ad.dispose();
            print('Ad closed.');
          },
        );

  static BannerAdListener get adBannerListener => kReleaseMode
      ? BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        )
      : BannerAdListener(
          onAdLoaded: (ad) => print('Ad loaded.'),
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          onAdOpened: (ad) => print('Ad opened.'),
          onAdClosed: (ad) {
            ad.dispose();
            print('Ad closed.');
          },
        );
}
