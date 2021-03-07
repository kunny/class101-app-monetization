import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static const _kBannerBottomPadding = 8.0;

  bool _initialized = false;

  bool _isInterstitialLoaded = false;

  BannerAd _banner;

  InterstitialAd _interstitial;

  Future<BannerAd> loadBanner() async {
    await _initialize();

    if (_banner != null) {
      return _banner;
    }

    Completer<BannerAd> adLoadResult = Completer<BannerAd>();

    _banner = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: _buildAdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          adLoadResult.complete(_banner);
        },
        onAdFailedToLoad: (ad, error) {
          adLoadResult.complete(null);
        },
      ),
    );

    _banner.load();

    return adLoadResult.future;
  }

  void loadInterstitial() {
    if (_interstitial != null && _isInterstitialLoaded) {
      return;
    }

    _interstitial = InterstitialAd(
      adUnitId: _getInterstitialAdUnitId(),
      request: _buildAdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          _isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          _isInterstitialLoaded = false;
        },
        onAdClosed: (ad) {
          _interstitial = null;
          _isInterstitialLoaded = false;
        },
      ),
    );

    _interstitial.load();
  }

  void showInterstitial() {
    if (!_isInterstitialLoaded) {
      return;
    }
    _interstitial.show();
  }

  EdgeInsets getBannerBottomPadding() {
    return EdgeInsets.only(bottom: _kBannerBottomPadding);
  }

  EdgeInsets getFabPadding(BuildContext context) {
    if (_banner == null) {
      return EdgeInsets.zero;
    }
    bool hasBottomNotch = MediaQuery.of(context).viewPadding.bottom > 0;
    int bannerHeight = _banner.size.height;
    double defaultFabPadding = bannerHeight + _kBannerBottomPadding;

    return EdgeInsets.only(
        bottom: hasBottomNotch ? defaultFabPadding + 16.0 : defaultFabPadding);
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
    throw StateError('Unsupported platform');
  }

  String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw StateError('Unsupported platform');
  }

  AdRequest _buildAdRequest() {
    return AdRequest(
      testDevices: [],
    );
  }

  void dispose() {
    if (_banner != null) {
      _banner.dispose();
    }
    if (_interstitial != null) {
      _interstitial.dispose();
    }
  }
}