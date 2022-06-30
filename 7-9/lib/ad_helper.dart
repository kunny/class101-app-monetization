import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  bool _initialized = false;

  void loadBanner(Function(BannerAd) onLoaded) async {
    await _initialize();

    final banner = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad as BannerAd),
      ),
    );

    banner.load();
  }

  void loadInterstitial(Function(InterstitialAd) onLoaded) async {
    await _initialize();

    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => onLoaded(ad),
        onAdFailedToLoad: (e) {
          print(e.toString());
        },
      ),
    );
  }

  Future<void> _initialize() async {
    if (!_initialized) {
      await _requestTrackingIfNeeded();
      await MobileAds.instance.initialize();
      _initialized = true;
    }
  }

  Future<void> _requestTrackingIfNeeded() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  String _getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw StateError("Unsupported platform");
  }

  String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw StateError('Unsupported platform');
  }
}
