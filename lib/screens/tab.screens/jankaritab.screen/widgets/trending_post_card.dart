import 'dart:async';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/app_url.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:agriChikitsa/widgets/audio_tts_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  late final PageController _pageController;
  Timer? _autoScrollTimer;

  static const int _initialPage = 1000;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _initialPage,
    );

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
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

    return SizedBox(
      height: dimension["height"]! * 0.22,
      width: dimension['width']!,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.trendingPosts.isEmpty ? 0 : null,
        itemBuilder: (context, index) {
          final realIndex = index % widget.trendingPosts.length;
          final post = widget.trendingPosts[realIndex];

          return InkWell(
            onTap: () => Utils.model(context, TrendingPostDetails(post: post)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: SizedBox(
                      height: (dimension["height"]! * 0.22) * 0.6,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: post.imageUrl,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder: (_, __, ___) => Skeleton(
                          height: 100,
                          width: double.infinity,
                          radius: 0,
                        ),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalization.of(context).locale.toString() == "en"
                                ? post.title
                                : post.hindiTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.favorite, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(post.likesCount.toString()),
                          ],
                        ),
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
                          Row(
                            children: [
                              AudioTtsButton(htmlContent: html),
                              InkWell(
                                  onTap: () async {
                                    final xfile = await useViewModel.shareFiles(post.imageUrl);
                                    await SharePlus.instance.share(ShareParams(
                                        text:
                                            "${post.hindiTitle}\nVisit here - ${AppUrl.shareLinkEndpoint}/${post.id}",
                                        files: [xfile]));
                                  },
                                  child: const SizedBox(
                                      height: 40, width: 40, child: Icon(Remix.share_line))),
                            ],
                          ),
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
