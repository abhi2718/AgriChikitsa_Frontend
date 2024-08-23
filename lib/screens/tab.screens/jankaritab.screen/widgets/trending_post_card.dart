import 'dart:async';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/app_url.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';

class CustomCarousel extends StatefulWidget {
  final List<dynamic> trendingPosts;
  const CustomCarousel({super.key, required this.trendingPosts});

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentPage < widget.trendingPosts.length - 1) {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return SizedBox(
      height: dimension["height"]! * 0.22,
      width: dimension['width']!,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.trendingPosts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () =>
                Utils.model(context, TrendingPostDetails(post: widget.trendingPosts[index])),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              color: AppColor.whiteColor,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   // borderRadius: BorderRadius.circular(20),
              //   // boxShadow: const [
              //   //   BoxShadow(
              //   //     color: Colors.black26,
              //   //     blurRadius: 10,
              //   //     offset: Offset(0, 5),
              //   //   ),
              //   // ],
              // ),
              child: Column(
                children: [
                  // CircleAvatar(
                  //   backgroundImage:
                  //       CachedNetworkImageProvider(widget.trendingPosts[index].imageUrl),
                  // ),
                  CachedNetworkImage(
                    imageUrl: widget.trendingPosts[index].imageUrl,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                      height: 100,
                      width: double.infinity,
                      radius: 0,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalization.of(context).locale.toString() == "en"
                              ? widget.trendingPosts[index].title
                              : widget.trendingPosts[index].hindiTitle,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(widget.trendingPosts[index].likesCount.toString())
                          ],
                        )
                      ],
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

class TrendingPostDetails extends HookWidget {
  final dynamic post;
  const TrendingPostDetails({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel = useMemoized(() => Provider.of<JankariViewModel>(context, listen: false));
    String html = AppLocalization.of(context).locale.toString() == "en"
        ? post.description
        : post.hindiDescription;
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return true;
      },
      child: Scaffold(
        // height: dimension['height']! - 180,
        // width: dimension['width'],
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: dimension['width'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const SizedBox(
                                height: 40, width: 30, child: Icon(Icons.arrow_back))),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Icon(
                            Remix.close_circle_line,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    post.youtubeUrl.isNotEmpty
                        ? Player(
                            videoUrl: post.youtubeUrl,
                            aspectRatio: 16 / 9,
                          )
                        : Container(
                            height: dimension['height']! * 0.40,
                            width: dimension['width'],
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: post.imageUrl,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      Skeleton(
                                    height: dimension['height']! * 0.40,
                                    width: dimension['width']!,
                                    radius: 16,
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  height: dimension['height']! * 0.40,
                                  width: dimension['width'],
                                  fit: BoxFit.fill,
                                ),
                                if (post.youtubeUrl.isNotEmpty)
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      size: 74,
                                    ),
                                  )
                              ],
                            )),
                    // InkWell(
                    //   onTap: () {
                    //     if (post.youtubeUrl.isNotEmpty) {
                    //       launchUrl(Uri.parse(post.youtubeUrl));
                    //     }
                    //   },
                    //   child: Container(
                    //       height: dimension['height']! * 0.40,
                    //       width: dimension['width'],
                    //       decoration: const BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(12),
                    //         ),
                    //       ),
                    //       child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(16),
                    //           child: Stack(
                    //             children: [
                    //               CachedNetworkImage(
                    //                 imageUrl: post.imageUrl,
                    //                 progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //                     Skeleton(
                    //                   height: dimension['height']! * 0.40,
                    //                   width: dimension['width']!,
                    //                   radius: 16,
                    //                 ),
                    //                 errorWidget: (context, url, error) => const Icon(Icons.error),
                    //                 height: dimension['height']! * 0.40,
                    //                 width: dimension['width'],
                    //                 fit: BoxFit.fill,
                    //               ),
                    //               if (post.youtubeUrl.isNotEmpty)
                    //                 const Align(
                    //                   alignment: Alignment.center,
                    //                   child: Icon(
                    //                     Icons.play_circle_fill,
                    //                     size: 74,
                    //                   ),
                    //                 )
                    //             ],
                    //           ))),
                    // ),
                    const SizedBox(
                      height: 23,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BaseText(
                              title: AppLocalization.of(context).locale.toString() == "en"
                                  ? post.title
                                  : post.hindiTitle,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          InkWell(
                              onTap: () async {
                                final xfile = await useViewModel.shareFiles(post.imageUrl);
                                await Share.shareXFiles([xfile],
                                    text:
                                        "${post.hindiTitle}\nVisit here - ${AppUrl.shareLinkEndpoint}/${post.id}");
                              },
                              child: const SizedBox(
                                  height: 40, width: 40, child: Icon(Remix.share_line))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: HtmlWidget(
                        html,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
