import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetwork extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? imageColor;
  final double borderRadius;

  const CustomCachedNetwork({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.imageColor,
    this.borderRadius = 300,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      useOldImageOnUrlChange: false,
      cacheKey: imageUrl,
      color: imageColor,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          width: double.infinity,
          height: double.infinity,
        ),
      ),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.photo, size: 30)),
      fit: fit,
      height: height,
      width: width,
    );
  }
}

class CustomCachedImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? imageColor;
  final bool isLoading;

  const CustomCachedImageNetwork({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.fitHeight,
    this.isLoading = false,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: imageUrl,
      imageUrl: imageUrl,
      useOldImageOnUrlChange: false,
      color: imageColor,
      placeholder: (context, url) => const Center(
          child: CupertinoActivityIndicator(radius: 20, color: Colors.white)),
      errorWidget: (context, url, error) => isLoading
          ? const Center(
              child:
                  CupertinoActivityIndicator(radius: 20, color: Colors.white))
          : const Center(child: Icon(Icons.photo, size: 30)),
      height: height,
      width: width,
      fit: fit,
    );
  }
}
