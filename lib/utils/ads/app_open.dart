import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scorecast/utils/constants.dart';

class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static int _retryAttempt = 0;

  /// Load an App Open Ad
  static void loadAd() {
    AppOpenAd.load(
      adUnitId: appOpenId,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _retryAttempt = 0; // Reset retry counter on success
        },
        onAdFailedToLoad: (error) {
          _retryAttempt++;

          // Retry with exponential backoff (max 64s)
          final int delay = (2 ^ _retryAttempt).clamp(1, 64);
          Future.delayed(Duration(seconds: delay), loadAd);
        },
      ),
    );
  }

  /// Show the Ad if ready
  static void showAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAd) {
      return;
    }

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        _appOpenAd?.dispose();
        _appOpenAd = null;
        loadAd(); // Load a new ad after closing
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        _appOpenAd?.dispose();
        _appOpenAd = null;
        loadAd(); // Retry loading the ad
      },
    );

    _appOpenAd!.show();
  }
}
