import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../res/app_url.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../jankari_view_model.dart';

class JankariPost extends HookWidget {
  final int index;
  final String subCategoryTitle;
  final ProfileViewModel profileViewModel;
  const JankariPost({
    super.key,
    required this.index,
    required this.subCategoryTitle,
    required this.profileViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel = useMemoized(() => Provider.of<JankariViewModel>(context, listen: false));
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.getJankariSubCategoryPost(context);
      });
    }, []);
    useEffect(() {
      if (useViewModel.jankariSubcategoryPostList.isEmpty) {
      } else {
        useViewModel.updateStats(
            context, 'post', useViewModel.jankariSubcategoryPostList[index].id);
      }
    }, [index]);
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return true;
      },
      child: SizedBox(
        height: dimension['height']! - 180,
        width: dimension['width'],
        child: Consumer<JankariViewModel>(
          builder: (context, provider, child) {
            String html = provider.jankariSubcategoryPostList.isNotEmpty
                ? profileViewModel.locale["language"] == "en"
                    ? provider.jankariSubcategoryPostList[index].description
                    : provider.jankariSubcategoryPostList[index].hindiDescription
                : "";
            return provider.jankariSubCategoryPostLoader
                ? SizedBox(
                    height: dimension['height']! - 180,
                    width: dimension['width'],
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Skeleton(height: 20, width: 60),
                          const SizedBox(
                            height: 10,
                          ),
                          Skeleton(height: dimension['height']! * 0.40, width: dimension['width']!),
                          const SizedBox(
                            height: 23,
                          ),
                          Skeleton(height: 10, width: 40),
                          const SizedBox(
                            height: 10,
                          ),
                          Skeleton(height: dimension['height']!, width: dimension['width']!),
                        ],
                      ),
                    ),
                  )
                : provider.jankariSubcategoryPostList.isEmpty
                    ? Center(
                        child: BaseText(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("noPostYet")
                                .toString(),
                            style: const TextStyle()),
                      )
                    : SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(subCategoryTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w300)),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          provider.togglePostLike(
                                              context,
                                              provider.jankariSubcategoryPostList[index].id,
                                              'like',
                                              provider.jankariSubcategoryPostList[index]);
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                  provider.jankariSubcategoryPostList[index].isLiked
                                                      ? Remix.thumb_up_fill
                                                      : Remix.thumb_up_line),
                                              BaseText(
                                                title: provider
                                                    .jankariSubcategoryPostList[index].likesCount
                                                    .toString(),
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          provider.togglePostLike(
                                              context,
                                              provider.jankariSubcategoryPostList[index].id,
                                              'dislike',
                                              provider.jankariSubcategoryPostList[index]);
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(provider
                                                      .jankariSubcategoryPostList[index].isDisLiked
                                                  ? Remix.thumb_down_fill
                                                  : Remix.thumb_down_line),
                                              BaseText(
                                                title: provider
                                                    .jankariSubcategoryPostList[index].dislikesCount
                                                    .toString(),
                                                style: const TextStyle(fontSize: 16),
                                              )
                                            ],
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          final xfile = await provider.shareFiles(
                                              provider.jankariSubcategoryPostList[index].imageUrl);
                                          await Share.shareXFiles([xfile],
                                              text:
                                                  "${provider.jankariSubcategoryPostList[index].hindiTitle}\nVisit here - ${AppUrl.shareLinkEndpoint}/${provider.jankariSubcategoryPostList[index].id}");
                                        },
                                        child: const SizedBox(
                                            height: 40, width: 40, child: Icon(Remix.share_line))),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (provider.jankariSubcategoryPostList[index].youtubeUrl
                                            .isNotEmpty) {
                                          launchUrl(Uri.parse(provider
                                              .jankariSubcategoryPostList[index].youtubeUrl));
                                        }
                                      },
                                      child: Container(
                                          height: dimension['height']! * 0.40,
                                          width: dimension['width'],
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: provider
                                                        .jankariSubcategoryPostList[index].imageUrl,
                                                    progressIndicatorBuilder:
                                                        (context, url, downloadProgress) =>
                                                            Skeleton(
                                                      height: dimension['height']! * 0.40,
                                                      width: dimension['width']!,
                                                      radius: 16,
                                                    ),
                                                    errorWidget: (context, url, error) =>
                                                        const Icon(Icons.error),
                                                    height: dimension['height']! * 0.40,
                                                    width: dimension['width'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                  if (provider.jankariSubcategoryPostList[index]
                                                      .youtubeUrl.isNotEmpty)
                                                    const Align(
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Icons.play_circle_fill,
                                                        size: 74,
                                                      ),
                                                    )
                                                ],
                                              ))),
                                    ),
                                    const SizedBox(
                                      height: 23,
                                    ),
                                    BaseText(
                                        title: profileViewModel.locale["language"] == "en"
                                            ? provider.jankariSubcategoryPostList[index].title
                                            : provider.jankariSubcategoryPostList[index].hindiTitle,
                                        style: const TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    HtmlWidget(
                                      html,
                                      textStyle: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
