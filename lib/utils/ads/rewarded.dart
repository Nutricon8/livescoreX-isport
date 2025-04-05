import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:livescore_x/utils/constants.dart';

class RewardedAdHelper {
  RewardedAd? _rewardedAd;
  static int _retryAttempt = 0;

  void loadAd() {
    RewardedAd.load(
      adUnitId: rewardedId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _retryAttempt = 0;
        },
        onAdFailedToLoad: (error) {
          _retryAttempt++;
          final int delay = (2 ^ _retryAttempt).clamp(1, 64);
          Future.delayed(Duration(seconds: delay), loadAd);
        },
      ),
    );
  }

  void showAd(Function onRewardOrComplete) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadAd();
          onRewardOrComplete(); // Continue process after ad dismissal
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadAd();
          onRewardOrComplete(); // Continue process if ad fails
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewardOrComplete(); // Handle reward & continue
        },
      );

      _rewardedAd = null; // Reset ad
    } else {
      // If no ad is available, continue immediately
      onRewardOrComplete();
    }
  }
}
