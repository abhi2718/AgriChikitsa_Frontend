import 'dart:async';

import 'package:agriChikitsa/model/weed_protection.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/widgets/pest_carousel.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';

class WeedCarousel extends StatefulWidget {
  final List<AdvisoryImage> images;
  const WeedCarousel({super.key, required this.images});

  @override
  State<WeedCarousel> createState() => _WeedCarouselState();
}

class _WeedCarouselState extends State<WeedCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    final initialPage =
        widget.images.length > 1 ? widget.images.length * 1000 : 0;
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: initialPage,
    );

    if (widget.images.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (_pageController.hasClients) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);

    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: dimension["height"]! * 0.35,
      width: dimension['width']!,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final actualIndex = index % widget.images.length;
          return InkWell(
            onTap: () => Utils.model(
                context, FullScreenImageViewer(imageUrl: widget.images[actualIndex].imageUrl)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: (dimension["height"]! * 0.30 - 8),
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: widget.images[actualIndex].imageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                            height: 100,
                            width: double.infinity,
                            radius: 0,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalization.of(context).locale.toString() == "en"
                          ? widget.images[actualIndex].nameEn
                          : widget.images[actualIndex].nameHi,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
