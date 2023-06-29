import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
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
                                    Container(
                                      height: dimension['height']! * 0.40,
                                      width: dimension['width'],
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: provider
                                              .jankariSubcategoryPostList[index]
                                              .youtubeUrl
                                              .isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: YoutubePlayerBuilder(
                                                player: YoutubePlayer(
                                                  controller:
                                                      YoutubePlayerController(
                                                    initialVideoId: YoutubePlayer
                                                            .convertUrlToId(provider
                                                                .jankariSubcategoryPostList[
                                                                    index]
                                                                .youtubeUrl) ??
                                                        '',
                                                    flags:
                                                        const YoutubePlayerFlags(
                                                      autoPlay: false,
                                                      mute: false,
                                                    ),
                                                  ),
                                                  showVideoProgressIndicator:
                                                      true,
                                                  progressIndicatorColor:
                                                      Colors.amber,
                                                ),
                                                builder: (context, player) {
                                                  return Column(
                                                    children: [
                                                      Scaffold(
                                                        body: player,
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                'https://d336izsd4bfvcs.cloudfront.net/${provider.jankariSubcategoryPostList[index].imageUrl.split('https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1]}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 23,
                                    ),
                                    BaseText(
                                        title: provider
                                            .jankariSubcategoryPostList[index]
                                            .title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BaseText(
                                        title: provider
                                            .jankariSubcategoryPostList[index]
                                            .description,
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
