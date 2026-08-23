import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage(
      {super.key, required this.images, required this.feed, required this.useViewModel});
  final List<dynamic> images;
  final dynamic feed;
  final dynamic useViewModel;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  final PageController _pageController = PageController();
  bool _isExpanded = false;

  bool _checkIsExpanded() {
    try {
      if (widget.useViewModel != null && widget.feed != null && widget.feed['_id'] != null) {
        return (widget.useViewModel.isExpanded(widget.feed['_id']) == true);
      }
    } catch (_) {}
    return _isExpanded;
  }

  void _toggleExpand() {
    try {
      if (widget.useViewModel != null && widget.feed != null && widget.feed['_id'] != null) {
        widget.useViewModel.toggleExpand(widget.feed['_id']);
        setState(() {});
        return;
      }
    } catch (_) {}
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final isExpanded = _checkIsExpanded();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.darkBlackColor,
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                if (index < 0 || index >= widget.images.length || widget.images[index] is! Map) {
                  return const SizedBox.shrink();
                }
                final imgUrl = widget.images[index]["originalUrl"] ??
                    widget.images[index]["thumbnailUrl"] ??
                    '';
                return CachedNetworkImage(
                  imageUrl: imgUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                    height: dimension["width"]! - 16,
                    width: dimension["width"]! - 16,
                    radius: 0,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 50, right: 16, left: 16, bottom: 16),
              decoration: BoxDecoration(
                color: AppColor.darkBlackColor.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.darkBlackColor.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.darkBlackColor.withOpacity(1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.feed["hindiCaption"] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: widget.feed["hindiCaption"],
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.whiteColor),
                              maxLines: isExpanded ? null : 2,
                            ),
                            if (widget.feed["hindiCaption"].length > 140)
                              InkWell(
                                onTap: _toggleExpand,
                                child: isExpanded
                                    ? Container()
                                    : const BaseText(
                                        title: "Read More",
                                        style: TextStyle(color: AppColor.hyperlinkColor),
                                      ),
                              ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: widget.feed["hindiCaption"] != null ? 16 : 0,
                  ),
                  Builder(
                    builder: (context) {
                      final userMap = widget.feed['user'] is Map ? widget.feed['user'] : {};
                      final profileImage = userMap['profileImage']?.toString() ?? '';
                      final userName = userMap['name']?.toString() ?? 'User';
                      final userHandler = userMap['userHandler']?.toString() ?? '@username';
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: profileImage.isNotEmpty
                                ? NetworkImage(profileImage)
                                : null,
                            child: profileImage.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.whiteColor),
                              ),
                              Text(
                                userHandler,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.whiteColor),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.images.length > 1)
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.images.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.white,
                          dotColor: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
