import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../jankari_view_model.dart';

class JankariPost extends HookWidget {
  final int index;
  final String subCategoryTitle;
  const JankariPost({
    super.key,
    required this.index,
    required this.subCategoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.getJankariSubCategoryPost(context);
      });
    }, []);
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
                          Skeleton(
                              height: dimension['height']! * 0.40,
                              width: dimension['width']!),
                          const SizedBox(
                            height: 23,
                          ),
                          Skeleton(height: 10, width: 40),
                          const SizedBox(
                            height: 10,
                          ),
                          Skeleton(
                              height: dimension['height']!,
                              width: dimension['width']!),
                        ],
                      ),
                    ),
                  )
                : provider.jankariSubcategoryPostList.isEmpty
                    ? Center(
                        child: BaseText(
                            title: AppLocalizations.of(context)!.nopostYethi,
                            style: const TextStyle()),
                      )
                    : SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            BaseText(
                                title: subCategoryTitle,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w300)),
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
                                        if (provider
                                            .jankariSubcategoryPostList[index]
                                            .youtubeUrl
                                            .isNotEmpty) {
                                          launchUrl(Uri.parse(provider
                                              .jankariSubcategoryPostList[index]
                                              .youtubeUrl));
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        'https://d336izsd4bfvcs.cloudfront.net/${provider.jankariSubcategoryPostList[index].imageUrl.split('https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1]}',
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Skeleton(
                                                      height:
                                                          dimension['height']! *
                                                              0.40,
                                                      width:
                                                          dimension['width']!,
                                                      radius: 16,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    height:
                                                        dimension['height']! *
                                                            0.40,
                                                    width: dimension['width'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                  if (provider
                                                      .jankariSubcategoryPostList[
                                                          index]
                                                      .youtubeUrl
                                                      .isNotEmpty)
                                                    const Align(
                                                      alignment:
                                                          Alignment.center,
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
                                        title: provider
                                            .jankariSubcategoryPostList[index]
                                            .hindiTitle,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BaseText(
                                        title: provider
                                            .jankariSubcategoryPostList[index]
                                            .hindiDescription,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300)),
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
