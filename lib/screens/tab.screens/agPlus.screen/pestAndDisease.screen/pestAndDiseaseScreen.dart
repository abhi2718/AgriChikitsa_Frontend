import 'package:agriChikitsa/model/pestAndDisease.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/widgets/pest_carousel.dart';
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

class PestAndDiseaseScreen extends HookWidget {
  final PestDiseaseObj selectedPestDisease;
  const PestAndDiseaseScreen({super.key, required this.selectedPestDisease});

  @override
  Widget build(BuildContext context) {
    final ttsViewModel =
        useMemoized(() => Provider.of<TextToSpeechViewModel>(context, listen: false));
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalization.of(context).locale.toString() == "en"
                    ? selectedPestDisease.nameEn
                    : selectedPestDisease.nameHi,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                "(${AppLocalization.of(context).locale.toString() == "en" ? selectedPestDisease.nameSciEn : selectedPestDisease.nameSciHi})",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
          String cleanHtml = Utils.cleanHtmlTags(
            AppLocalization.of(context).locale.toString() == "en"
                ? selectedPestDisease.contentEn
                : selectedPestDisease.contentHi,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ttsViewModel.setText(cleanHtml);
          });
          // return provider.isWeedDataLoading
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PestsCarousel(images: selectedPestDisease.images),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 14),
                  child: HtmlWidget(AppLocalization.of(context).locale.toString() == "en"
                      ? selectedPestDisease.contentEn
                      : selectedPestDisease.contentHi),
                ),
              ],
            ),
          );
        }),
        floatingActionButton: Consumer<TextToSpeechViewModel>(
          builder: (context, vm, _) {
            // if (advisory == null || useViewModel.isWeedDataLoading) return const SizedBox();
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

class PestAndDiseaseSelectModal extends StatelessWidget {
  const PestAndDiseaseSelectModal({super.key});

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
                  const AllPestsDiseasesScreen(
                    selectedType: "pest",
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
                    child: Image.asset(
                      "assets/images/pestBg.jpg",
                      width: 40,
                      fit: BoxFit.cover,
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
                              .getTranslatedValue("pestProtectionTitle")
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
                  const AllPestsDiseasesScreen(
                    selectedType: "disease",
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
                    child: Image.asset(
                      "assets/images/diseaseBg.jpg",
                      width: 40,
                      fit: BoxFit.cover,
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
                              .getTranslatedValue("diseaseProtectionTitle")
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

class AllPestsDiseasesScreen extends HookWidget {
  final String selectedType;
  const AllPestsDiseasesScreen({super.key, required this.selectedType});

  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(() => Provider.of<AGPlusViewModel>(context, listen: false));
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.getPestsDiseaseData(context, useViewModel.selectedPlot.cropId);
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.notificationBgColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "${AppLocalization.of(context).getTranslatedValue("trendingPestsDisease").toString()} ${AppLocalization.of(context).getTranslatedValue(selectedType).toString()}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
        return provider.isPestDataLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.extraDark,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: selectedType == "pest"
                      ? provider.pestDiseaseData.pests.length
                      : provider.pestDiseaseData.diseases.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final PestDiseaseObj item = selectedType == "pest"
                        ? provider.pestDiseaseData.pests[index]
                        : provider.pestDiseaseData.diseases[index];

                    return GestureDetector(
                      onTap: () {
                        Utils.model(
                          context,
                          PestAndDiseaseScreen(selectedPestDisease: item),
                        );
                      },
                      child: Card(
                        color: AppColor.whiteColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: CachedNetworkImage(
                                imageUrl: selectedType == "pest" ? item.images[0] : item.images[0],
                                fit: BoxFit.cover,
                                height: 150, // fixed height for image
                                width: double.infinity,
                                placeholder: (context, url) => Skeleton(
                                  height: 150,
                                  width: double.infinity,
                                  radius: 12,
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedType == "pest"
                                        ? AppLocalization.of(context).locale.toString() == "en"
                                            ? item.nameEn
                                            : item.nameHi
                                        : AppLocalization.of(context).locale.toString() == "en"
                                            ? item.nameEn
                                            : item.nameHi,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "(${selectedType == "pest" ? AppLocalization.of(context).locale.toString() == "en" ? item.nameSciEn : item.nameSciHi : AppLocalization.of(context).locale.toString() == "en" ? item.nameSciEn : item.nameSciHi})",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                    ),
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
      }),
    );
  }
}
