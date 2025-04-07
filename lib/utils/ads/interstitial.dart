import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pulsescore/utils/constants.dart';

class InterstitialAdHelper {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  static int _retryAttempt = 0;
  void loadAd() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          _retryAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
          _retryAttempt++;

          // Retry with exponential backoff (max 64s)
          final int delay = (2 ^ _retryAttempt).clamp(1, 64);
          Future.delayed(Duration(seconds: delay), loadAd);
        },
      ),
    );
  }

  void showAd(Function? onComplete) {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _isAdLoaded = false;
          loadAd(); // Load new ad after dismissal
          if (onComplete != null) {
            onComplete(); // Navigate after ad
          }
        },
      );
      _interstitialAd!.show();
    } else {
      onComplete?.call(); // If no ad, continue immediately
    }
  }
}
