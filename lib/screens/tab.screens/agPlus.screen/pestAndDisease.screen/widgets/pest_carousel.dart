import 'dart:async';

import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PestsCarousel extends StatefulWidget {
  final List<dynamic> images;
  const PestsCarousel({super.key, required this.images});

  @override
  State<PestsCarousel> createState() => _PestsCarouselState();
}

class _PestsCarouselState extends State<PestsCarousel> {
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

    if (widget.images.length == 1) {
      // Show full-width single image
      return SizedBox(
        height: dimension["height"]! * 0.35,
        width: double.infinity,
        child: InkWell(
          onTap: () => Utils.model(
            context,
            FullScreenImageViewer(imageUrl: widget.images[0]),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.images[0].image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: dimension["height"]! * 0.35,
            progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
              height: 100,
              width: double.infinity,
              radius: 0,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }

    // Else show carousel
    return SizedBox(
      height: dimension["height"]! * 0.35,
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final actualIndex = index % widget.images.length;
          return InkWell(
            onTap: () => Utils.model(
              context,
              FullScreenImageViewer(imageUrl: widget.images[actualIndex].image),
            ),
            child: AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: (dimension["height"]! * 0.3),
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: widget.images[actualIndex].image,
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
                  const SizedBox(width: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Center(
          child: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        imageProvider: CachedNetworkImageProvider(imageUrl),
      )),
    );
  }
}
