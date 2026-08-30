import 'dart:io';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/category_button.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed_video_player.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';

class CreatePostScreen extends HookWidget {
  const CreatePostScreen({super.key, this.feed, this.isEdit = false, required this.onPostCreated});
  final dynamic feed;
  final bool isEdit;
  final VoidCallback onPostCreated;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<CreatePostModel>(context, listen: false));
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final hometabViewModel =
        useMemoized(() => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: true);

    print(feed);
    print(isEdit);

    useEffect(() {
      useViewModel.fetchFeedsCategory(context, hometabViewModel);
      if (feed != null) {
        useViewModel.setFeedData(feed);
      }
      return () {
        if (!useViewModel.isUploading) {
          useViewModel.reinitialize();
        }
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading:
            InkWell(onTap: () => useViewModel.goBack(context), child: const Icon(Icons.arrow_back)),
        title: BaseText(
          title: AppLocalization.of(context)
              .getTranslatedValue(feed != null ? "editPostTitle" : "createPost")
              .toString(),
          style: GoogleFonts.inter(
              color: AppColor.darkBlackColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<CreatePostModel>(builder: (context, provider, child) {
                final PageController pageController = PageController();
                return InkWell(
                    onTap: provider.isPostPicked
                        ? null
                        : () {
                            Utils.model(
                                context,
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  height: dimension['height']! * 0.18,
                                  width: dimension['width']!,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                            Icons.collections,
                                            color: AppColor.extraDark,
                                          ),
                                          title: Text(AppLocalization.of(context)
                                              .getTranslatedValue("uploadImagePost")
                                              .toString()),
                                          onTap: () {
                                            provider.pickPostImages(context, dimension);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.video_library,
                                            color: AppColor.extraDark,
                                          ),
                                          title: Text(AppLocalization.of(context)
                                              .getTranslatedValue("uploadVideoPost")
                                              .toString()),
                                          onTap: () {
                                            Utils.model(
                                                context,
                                                Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  height: dimension['height']! * 0.22,
                                                  width: dimension['width']!,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 16.0, vertical: 4.0),
                                                          child: Text(
                                                            AppLocalization.of(context)
                                                                .getTranslatedValue("pickVideoFrom")
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          leading: const Icon(
                                                            Icons.video_library,
                                                            color: AppColor.extraDark,
                                                          ),
                                                          title: Text(AppLocalization.of(context)
                                                              .getTranslatedValue("gallery")
                                                              .toString()),
                                                          onTap: () {
                                                            provider.pickPostVideo(
                                                                context, authService);
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: const Icon(
                                                            Icons.smart_display,
                                                            color: AppColor.extraDark,
                                                          ),
                                                          title: Text(AppLocalization.of(context)
                                                              .getTranslatedValue("youtube")
                                                              .toString()),
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext dialogContext) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(20)),
                                                                  child: IntrinsicHeight(
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              16.0),
                                                                      child: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            AppLocalization.of(
                                                                                    context)
                                                                                .getTranslatedValue(
                                                                                    "youtubeLink")
                                                                                .toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                                    fontSize: 20,
                                                                                    fontWeight:
                                                                                        FontWeight.w500),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 16),
                                                                          TextField(
                                                                            controller: provider
                                                                                .youtubeUrlController,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: AppLocalization
                                                                                      .of(context)
                                                                                  .getTranslatedValue(
                                                                                      "enterHere")
                                                                                  .toString(),
                                                                              enabledBorder:
                                                                                  OutlineInputBorder(
                                                                                borderSide:
                                                                                    const BorderSide(
                                                                                        color:
                                                                                            Colors.grey),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            8.0),
                                                                              ),
                                                                              focusedBorder:
                                                                                  OutlineInputBorder(
                                                                                borderSide:
                                                                                    const BorderSide(
                                                                                        color:
                                                                                            Colors.green),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              provider
                                                                                  .addYoutubeUrl(
                                                                                      context);
                                                                            },
                                                                            child: Text(
                                                                              AppLocalization.of(
                                                                                      context)
                                                                                  .getTranslatedValue(
                                                                                      "submitButton")
                                                                                  .toString(),
                                                                              style:
                                                                                  const TextStyle(
                                                                                      color:
                                                                                          Colors.green),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: useViewModel.youtubeVideoPath.isNotEmpty
                            ? 200
                            : dimension['width']! - 16,
                        width: dimension['width']! - 16,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.darkColor, width: 2.0)),
                        child: !useViewModel.isPostPicked
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/gallery.png',
                                      width: 26,
                                      height: 26,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BaseText(
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("imageUploadCaptionPost")
                                            .toString(),
                                        style: const TextStyle()),
                                  ],
                                ),
                              )
                            : useViewModel.imagePath.isEmpty && useViewModel.postImages.isEmpty
                                ? feed != null
                                    ? feed['mediaType'] == 'video'
                                        ? PostWidget(videoUrl: feed['videoUrl'])
                                        : Player(videoUrl: feed['videoUrl'], aspectRatio: 16 / 9)
                                    : useViewModel.youtubeVideoPath.isNotEmpty
                                        ? Player(
                                            videoUrl: useViewModel.youtubeVideoPath,
                                            aspectRatio: 16 / 9)
                                        // ? Text("Hey")
                                        : useViewModel.videoController != null && useViewModel.videoController!.value.isInitialized
                                            ? VideoPlayer(useViewModel
                                                .videoController!) // Show video player once initialized
                                            : const Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColor.extraDark,
                                                ),
                                              )
                                : feed != null
                                    // ? CachedNetworkImage(
                                    //     imageUrl: provider.imagePath,
                                    //     fit: BoxFit.cover,
                                    //   )
                                    ? Stack(
                                        children: [
                                          PageView.builder(
                                            controller: pageController,
                                            itemCount: provider.imagePath.length,
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: provider.imagePath[index]
                                                        ["thumbnailUrl"],
                                                    fit: BoxFit.cover,
                                                    height: dimension['width']! - 16,
                                                    width: dimension['width']! - 16,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          if (provider.imagePath.length > 1)
                                            Positioned(
                                              bottom: 16,
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: SmoothPageIndicator(
                                                  controller: pageController,
                                                  count: provider.imagePath.length,
                                                  effect: WormEffect(
                                                    activeDotColor: Colors.red,
                                                    dotColor: Colors.grey.withOpacity(0.5),
                                                    dotHeight: 8,
                                                    dotWidth: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          PageView.builder(
                                            controller: pageController,
                                            itemCount: provider.postImages.length,
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  Image.file(
                                                    File(provider
                                                        .postImages[index].croppedFile!.path),
                                                    height: dimension['width']! - 16,
                                                    width: dimension['width']! - 16,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    top: 16,
                                                    right: 16,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.cancel,
                                                          color: Colors.red, size: 30),
                                                      onPressed: () => provider.removeImage(index),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          if (provider.postImages.length > 1)
                                            Positioned(
                                              bottom: 16,
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: SmoothPageIndicator(
                                                  controller: pageController,
                                                  count: provider.postImages.length,
                                                  effect: WormEffect(
                                                    activeDotColor: Colors.red,
                                                    dotColor: Colors.grey.withOpacity(0.5),
                                                    dotHeight: 8,
                                                    dotWidth: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )));
              }),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLength: 225,
                controller: useViewModel.captionController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalization.of(context).getTranslatedValue("enterCaption").toString(),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.darkColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  useViewModel.onSavedCaptionField(value);
                },
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                onSubmitted: (_) {
                  useViewModel.onSavedCaptionField(useViewModel.captionController.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {
                  useViewModel.handleUserInput(context);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BaseText(
                  title: AppLocalization.of(context)
                      .getTranslatedValue("selectCategoryPost")
                      .toString(),
                  style: const TextStyle()),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: dimension["width"],
                child: SizedBox(
                  height: 30,
                  child: Consumer<CreatePostModel>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.categoriesList.length,
                          itemBuilder: (context, index) {
                            return CategoryButton(
                              profileViewModel: profileViewModel,
                              provider: provider,
                              category: provider.categoriesList[index],
                              onTap: () {
                                provider.setActiveState(
                                  context,
                                  provider.categoriesList[index],
                                  provider.categoriesList[index].isActive,
                                );
                              },
                            );
                          });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Consumer<CreatePostModel>(
                builder: (context, provider, child) => CustomElevatedButton(
                    title: AppLocalization.of(context)
                        .getTranslatedValue(feed != null ? "updateTitle" : "submitButton")
                        .toString(),
                    loading: provider.buttonloading,
                    width: dimension["width"]! - 32,
                    onPress: () {
                      feed != null
                          ? useViewModel.updatePost(context, feed['_id'], isEdit)
                          : useViewModel.createPost(context, onPostCreated);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
