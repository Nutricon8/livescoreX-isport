import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:livescorex/utils/constants.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  /// Loads the banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner, // Standard banner size (320x50)
      adUnitId: bannerId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdReady = false;
          ad.dispose();
          _loadBannerAd();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Container(
          alignment: Alignment.center,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        )
        : SizedBox.shrink(); // Hides the banner if it's not ready
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
