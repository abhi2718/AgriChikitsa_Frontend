import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage(
      {super.key, required this.image, required this.feed, required this.useViewModel});
  final String image;
  final dynamic feed;
  final HomeTabViewModel useViewModel;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
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
          )
        ],
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: PageView.builder(
          //     controller: _pageController,
          //     itemCount: 1,
          //     itemBuilder: (context, index) {
          //       return Image.network(
          //         widget.image,
          //         fit: BoxFit.contain,
          //       );
          //     },
          //   ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 80, right: 16, left: 16, bottom: 16),
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
                    AppColor.darkBlackColor.withOpacity(1), // Start color
                    Colors.transparent, // End color
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              maxLines:
                                  widget.useViewModel.isExpanded(widget.feed['_id']) ? null : 2,
                            ),
                            if (widget.feed["hindiCaption"].length > 140)
                              InkWell(
                                onTap: () => widget.useViewModel.toggleExpand(widget.feed['_id']),
                                child: widget.useViewModel.isExpanded(widget.feed['_id'])
                                    ? Container()
                                    : const BaseText(
                                        title: "Read More",
                                        style: TextStyle(color: AppColor.hyperlinkColor),
                                      ),
                              ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.feed['user']['profileImage']),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.feed['user']['name'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.whiteColor),
                          ),
                          Text(
                            widget.feed['user']['userHandler'] ?? "@username",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColor.whiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.image,
              progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                height: dimension["width"]! - 16,
                width: dimension["width"]! - 16,
                radius: 0,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.contain,
            ),
          ),
          // For multiple image
          // Positioned(
          //   bottom: 30,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: SmoothPageIndicator(
          //       controller: _pageController,
          //       count: widget.currentReview.images.length,
          //       effect: ExpandingDotsEffect(
          //         dotHeight: 8,
          //         dotWidth: 8,
          //         activeDotColor: AppColor.whiteColor,
          //         dotColor: AppColor.whiteColor.withOpacity(0.5),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
