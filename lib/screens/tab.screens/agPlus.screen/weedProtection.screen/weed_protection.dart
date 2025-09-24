import 'package:agriChikitsa/model/weed_protection.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weedProtection.screen/widgets/weed_carousel.dart';
import 'package:agriChikitsa/screens/tab.screens/textToSpeech/textToSpeechViewModel.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

class WeedProtectionScreen extends HookWidget {
  final String selectedWeedType;
  const WeedProtectionScreen({super.key, required this.selectedWeedType});

  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(() => Provider.of<AGPlusViewModel>(context, listen: false));
    final ttsViewModel =
        useMemoized(() => Provider.of<TextToSpeechViewModel>(context, listen: false));
    final beforeExpanded = useState(false);
    final afterExpanded = useState(false);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.getWeedProtectionData(context, useViewModel.selectedPlot.cropId);
        ttsViewModel.reinitalize();
      });
      return null;
    }, []);
    return WillPopScope(
      onWillPop: () async {
        ttsViewModel.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.notificationBgColor,
          foregroundColor: AppColor.darkBlackColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ttsViewModel.stop();
              Navigator.pop(context);
            },
          ),
          title: Text(
            AppLocalization.of(context)
                .getTranslatedValue("${selectedWeedType}ProtectionAppBarTitle")
                .toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
          return provider.isWeedDataLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                )
              : Builder(builder: (context) {
                  final protection = provider.weedProtection;
                  if (protection.getByType(selectedWeedType).isEmpty) {
                    return Center(
                      child: Text(AppLocalization.of(context)
                          .getTranslatedValue("noWeedAdvisory")
                          .toString()),
                    );
                  }
                  WeedAdvisory selectedAdvisory = protection.getByType(selectedWeedType)[0];
                  if (selectedAdvisory.advisoryType == "organic") {
                    String cleanHtml = Utils.cleanHtmlTags(
                      AppLocalization.of(context).locale.toString() == "en"
                          ? selectedAdvisory.advisoryBeforeEn
                          : selectedAdvisory.advisoryBeforeHi,
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ttsViewModel.setText(cleanHtml);
                    });
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                          child: Center(
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue("weedProtectionHeader")
                                  .toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        WeedCarousel(images: selectedAdvisory.imagesBefore),
                        if (selectedAdvisory.advisoryType == "organic")
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColor.notificationBgColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                    offset: Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValue("jankariTab")
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
                                    color: AppColor.whiteColor,
                                    child: HtmlWidget(
                                        AppLocalization.of(context).locale.toString() == "en"
                                            ? selectedAdvisory.advisoryBeforeEn
                                            : selectedAdvisory.advisoryBeforeHi))
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExpansionTile(
                                  title: Text(AppLocalization.of(context)
                                      .getTranslatedValue("chemicalBeforeTitle")
                                      .toString()),
                                  collapsedBackgroundColor: AppColor.notificationBgColor,
                                  onExpansionChanged: (expanded) {
                                    beforeExpanded.value = expanded;
                                    if (expanded) {
                                      ttsViewModel.reinitalize();
                                      String cleanHtml = Utils.cleanHtmlTags(
                                          AppLocalization.of(context).locale.toString() == "en"
                                              ? selectedAdvisory.advisoryBeforeEn
                                              : selectedAdvisory.advisoryBeforeHi);
                                      ttsViewModel.setText(cleanHtml);
                                    } else {
                                      ttsViewModel.stop();
                                    }
                                  },
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: HtmlWidget(
                                          AppLocalization.of(context).locale.toString() == "en"
                                              ? selectedAdvisory.advisoryBeforeEn
                                              : selectedAdvisory.advisoryBeforeHi),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ExpansionTile(
                                  collapsedBackgroundColor: AppColor.notificationBgColor,
                                  title: Text(AppLocalization.of(context)
                                      .getTranslatedValue("chemicalAfterTitle")
                                      .toString()),
                                  onExpansionChanged: (expanded) {
                                    afterExpanded.value = expanded;
                                    if (expanded) {
                                      ttsViewModel.reinitalize();
                                      String cleanHtml = Utils.cleanHtmlTags(
                                          AppLocalization.of(context).locale.toString() == "en"
                                              ? selectedAdvisory.advisoryAfterEn
                                              : selectedAdvisory.advisoryAfterHi);
                                      ttsViewModel.setText(cleanHtml);
                                      // ttsViewModel.setText("Chl ja bhosdu");
                                    } else {
                                      ttsViewModel.stop();
                                    }
                                  },
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: HtmlWidget(
                                            AppLocalization.of(context).locale.toString() == "en"
                                                ? selectedAdvisory.advisoryAfterEn
                                                : selectedAdvisory.advisoryAfterHi)),
                                  ],
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                });
        }),
        floatingActionButton: Consumer<TextToSpeechViewModel>(
          builder: (context, vm, _) {
            final advisory = useViewModel.weedProtection.getByType(selectedWeedType).isNotEmpty
                ? useViewModel.weedProtection.getByType(selectedWeedType)[0]
                : null;

            if (advisory == null || useViewModel.isWeedDataLoading) return const SizedBox();

            bool showFab =
                advisory.advisoryType == "organic" || beforeExpanded.value || afterExpanded.value;

            if (!showFab) return const SizedBox();
            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: AppColor.darkColor,
                    child: vm.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          )
                        : const Icon(
                            Icons.mic,
                            color: AppColor.whiteColor,
                          ),
                    onPressed: () {
                      if (vm.isLoading) {
                        return;
                      }
                      vm.speak(context, languageCode: "hi-IN");
                    },
                  ),
                ),
                if (vm.isSpeaking)
                  Positioned(
                    bottom: 80,
                    right: 0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: vm.isLoading
                          ? () {
                              return;
                            }
                          : vm.isPaused
                              ? () => {vm.resume(context)}
                              : vm.pause,
                      child: vm.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColor.whiteColor,
                              ),
                            )
                          : Icon(
                              vm.isPaused ? Icons.play_arrow : Icons.pause,
                              color: AppColor.darkColor,
                            ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WeedCategorySelectModal extends StatelessWidget {
  const WeedCategorySelectModal({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      height: dimension["height"]! * 0.3,
      width: dimension["width"]!,
      decoration:
          BoxDecoration(color: AppColor.whiteColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Utils.model(
                  context,
                  const WeedProtectionScreen(
                    selectedWeedType: "organic",
                  ));
            },
            child: Container(
              height: 150,
              width: dimension['width']! * 0.4,
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: "https://kj1bcdn.b-cdn.net/media/40752/mulching.jpg",
                      progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                        height: 40,
                        width: 40,
                        radius: 0,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 40,
                      fit: BoxFit.fill,
                      height: 40,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BaseText(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("organicTitle")
                              .toString(),
                          style: const TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Utils.model(
                  context,
                  const WeedProtectionScreen(
                    selectedWeedType: "chemical",
                  ));
            },
            child: Container(
              height: 150,
              width: dimension['width']! * 0.4,
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: "https://kj1bcdn.b-cdn.net/media/40752/mulching.jpg",
                      progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                        height: 40,
                        width: 40,
                        radius: 0,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 40,
                      fit: BoxFit.fill,
                      height: 40,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BaseText(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("chemicalTitle")
                              .toString(),
                          style: const TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
