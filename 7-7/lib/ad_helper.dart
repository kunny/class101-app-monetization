import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {

  bool _initialized = false;

  BannerAd? _banner;

  void loadBanner(Function(BannerAd) onBannerLoaded) async {
    await _initialize();

    if (_banner != null) {
      onBannerLoaded(_banner!);
      return;
    }

    _banner = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onBannerLoaded(ad as BannerAd);
        },
      ),
    );

    _banner!.load();
  }

  EdgeInsets getFabPadding(BuildContext context) {
    double bannerHeight = 50.0;
    bool hasBottomNavigation = MediaQuery.of(context).viewPadding.bottom > 0;
    double bottomPadding = hasBottomNavigation ? 16.0 : 0.0;
    return EdgeInsets.only(bottom: bannerHeight + bottomPadding);
  }

  Future<void> _initialize() async {
    if (!_initialized) {
      await MobileAds.instance.initialize();
      _initialized = true;
    }
  }

  String _getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw StateError("Unsupported platform");
  }

  void dispose() {
    if (_banner != null) {
      _banner!.dispose();
    }
  }
}
