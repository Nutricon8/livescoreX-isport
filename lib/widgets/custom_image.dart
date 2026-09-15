import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imageString;
  final double width;
  final double height;
  final bool isFilled;
  final bool isCover;

  const CustomImage({
    super.key,
    required this.imageString,
    required this.width,
    required this.height,
    this.isFilled = false,
    this.isCover = false,
  });

  bool get _hasValidUrl {
    if (imageString.isEmpty) return false;
    final uri = Uri.tryParse(imageString);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    // Short-circuit before Image.network so we don't pay the cost of a
    // failed network attempt for obviously-invalid strings.
    /*if (!_hasValidUrl) {
      return _fallback();
    }*/

    return Image.network(
      'https://zq.titan007.com/Image/team/images/27984/1h07nnt8qmb.png?win007=sell', //imageString,
      height: height,
      width: width,
      fit: isCover
          ? BoxFit.cover
          : isFilled
              ? BoxFit.fill
              : null,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('CustomImage failed for "$imageString": $error');
        return _fallback();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }

  Widget _fallback() {
    return SizedBox(
      width: width,
      height: height,
      child: Icon(Icons.sports_soccer, size: width),
    );
  }
}

/*import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imageString;
  final double width;
  final double height;
  final bool isFilled;
  final bool isCover;

  const CustomImage({
    super.key,
    required this.imageString,
    required this.width,
    required this.height,
    this.isFilled = false,
    this.isCover = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageString,
      height: height,
      width: width,
      fit:
          isCover
              ? BoxFit.cover
              : isFilled
              ? BoxFit.fill
              : null,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.sports_soccer, size: width); // Fallback icon
      },
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        //return const Center(child: Icon(Icons.sports_soccer, size: width));
        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}*/
