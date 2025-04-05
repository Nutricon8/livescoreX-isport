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
}
