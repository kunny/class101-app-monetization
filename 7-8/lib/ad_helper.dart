import 'dart:async';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdHelper {
  bool _initialized = false;

  bool _isBannerShown = false;

  bool _isInterstitialLoaded = false;

  BannerAd _banner;

  InterstitialAd _interstitial;

  Future<bool> loadBanner() async {
    await _initialize();

    if (_banner != null) {
      return _banner.isLoaded();
    }

    Completer<bool> adLoadResult = Completer<bool>();

    _banner = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      listener: (event) {
        if (event == MobileAdEvent.loaded) {
          adLoadResult.complete(true);
        } else if (event == MobileAdEvent.failedToLoad) {
          adLoadResult.complete(false);
        }
      },
    );

    _banner.load();

    return adLoadResult.future;
  }

  Future<bool> showBanner() async {
    if (_isBannerShown) {
      return false;
    }

    await _banner.show(anchorType: AnchorType.bottom);
    _isBannerShown = true;
    return true;
  }

  void loadInterstitial() {
    if (_interstitial != null && _isInterstitialLoaded) {
      return;
    }

    _interstitial = InterstitialAd(
      adUnitId: _getInterstitialAdUnitId(),
      listener: (event) {
        if (event == MobileAdEvent.loaded) {
          _isInterstitialLoaded = true;
        } else if (event == MobileAdEvent.failedToLoad) {
          _isInterstitialLoaded = false;
        } else if (event == MobileAdEvent.closed) {
          _interstitial = null;
          _isInterstitialLoaded = false;
        }
      }
    );

    _interstitial.load();
  }

  void showInterstitial() {
    if (!_isInterstitialLoaded) {
      return;
    }
    _interstitial.show();
  }

  EdgeInsets getContentPadding(BuildContext context) {
    double viewPadding = MediaQuery.of(context).viewPadding.bottom;
    double bottomPadding = _isBannerShown ? 66.0 : 16.0;
    return EdgeInsets.fromLTRB(12.0, 16.0, 12.0, viewPadding + bottomPadding);
  }

  EdgeInsets getFabPadding(BuildContext context) {
    if (!_isBannerShown) {
      return EdgeInsets.zero;
    }
    bool hasBottomNotch = MediaQuery.of(context).viewPadding.bottom > 0;
    return EdgeInsets.only(bottom: hasBottomNotch ? 66.0 : 50.0);
  }

  Future<void> _initialize() async {
    if (!_initialized) {
      await FirebaseAdMob.instance.initialize(appId: _getApplicationId());
      _initialized = true;
    }
  }

  String _getApplicationId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544~3347511713';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544~1458002511';
    }
    throw StateError('Unsupported platform');
  }

  String _getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return BannerAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return BannerAd.testAdUnitId;
    }
    throw StateError('Unsupported platform');
  }

  String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return InterstitialAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return InterstitialAd.testAdUnitId;
    }
    throw StateError('Unsupported platform');
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