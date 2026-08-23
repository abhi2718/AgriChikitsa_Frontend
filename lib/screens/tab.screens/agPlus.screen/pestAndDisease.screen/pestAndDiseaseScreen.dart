import 'package:agriChikitsa/model/pestAndDisease.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/helper/pest_medicine.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/widgets/pest_carousel.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weedProtection.screen/widgets/button_tab.dart';
import 'package:agriChikitsa/screens/tab.screens/textToSpeech/audio_play_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:agriChikitsa/widgets/audio_tts_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

class PestAndDiseaseScreen extends HookWidget {
  final PestDiseaseObj selectedPestDisease;
  final AGPlusViewModel useViewModel;
  const PestAndDiseaseScreen(
      {super.key, required this.selectedPestDisease, required this.useViewModel});

  @override
  Widget build(BuildContext context) {
    final audioViewModel =
        useMemoized(() => Provider.of<AudioPlayerViewModel>(context, listen: false));
    final resolvedData = useState<PestDiseaseResolvedData?>(null);
    final localeCode = AppLocalization.of(context).locale.toString();
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        audioViewModel.reinitalize();

        resolvedData.value = await useViewModel.resolvePestDiseaseDetails(
          context,
          selectedPestDisease.id,
        );
      });
      return null;
    }, []);
    useEffect(() {
      if (!useViewModel.isPestDetailsLoading && resolvedData.value != null) {
        final url = localeCode == "en" ? resolvedData.value!.audioEn : resolvedData.value!.audioHi;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          audioViewModel.setAudioUrl(url);
        });
      }
      return null;
    }, [
      useViewModel.isPestDetailsLoading,
      resolvedData.value,
      localeCode,
    ]);

    return WillPopScope(
      onWillPop: () async {
        audioViewModel.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalization.of(context).locale.toString() == "en"
                    ? selectedPestDisease.nameEn
                    : selectedPestDisease.nameHi,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "(${AppLocalization.of(context).locale.toString() == "en" ? selectedPestDisease.nameSciEn : selectedPestDisease.nameSciHi})",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final locale = AppLocalization.of(context).locale.toString();
            if (locale == "en" &&
                selectedPestDisease.audioEn != null &&
                selectedPestDisease.audioEn!.isNotEmpty) {
              audioViewModel.setAudioUrl(selectedPestDisease.audioEn!);
            } else if (locale == "hi" &&
                selectedPestDisease.audioHi != null &&
                selectedPestDisease.audioHi!.isNotEmpty) {
              audioViewModel.setAudioUrl(selectedPestDisease.audioHi!);
            } else {
              audioViewModel.setAudioUrl("");
            }
          });
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PestsCarousel(images: selectedPestDisease.carousel),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      provider.isPestDetailsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : resolvedData.value == null
                              ? const SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: resolvedData.value!.details.map((detail) {
                                    final isEn =
                                        AppLocalization.of(context).locale.toString() == "en";
                                    final detailContent =
                                        isEn ? detail.contentEn : detail.contentHi;
                                    final hasContent =
                                        Utils.cleanHtmlTags(detailContent).trim().isNotEmpty;
                                    return (detailContent.isEmpty && detail.solutions.isEmpty)
                                        ? const SizedBox.shrink()
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 22, horizontal: 14),
                                            margin: const EdgeInsets.only(bottom: 12),
                                            decoration: BoxDecoration(
                                                color: AppColor.whiteColor,
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: BaseText(
                                                          title:
                                                              isEn ? detail.titleEn : detail.titleHi,
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15)),
                                                    ),
                                                    if (hasContent)
                                                      AudioTtsButton(
                                                        htmlContent: detailContent,
                                                      ),
                                                  ],
                                                ),
                                                if (hasContent) ...[
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  HtmlWidget(
                                                    detailContent,
                                                  ),
                                                ],
                                                if (detail.solutions.isNotEmpty) ...[
                                                  const SizedBox(height: 8),
                                                  Column(
                                                    children: detail.solutions.map((solution) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            vertical: 4.0),
                                                        child: ButtonTab(
                                                          text: isEn
                                                              ? solution.nameEn
                                                              : solution.nameHi,
                                                          onPressed: () {
                                                            Utils.model(
                                                                context,
                                                                PestMedicineScreen(
                                                                    selectedSolution: solution));
                                                          },
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          );
                                  }).toList(),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
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
        useViewModel.getPestsDiseaseList(context, useViewModel.selectedPlot, selectedType);
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
            : (selectedType == "pest" && provider.pestDiseaseData.pests.isEmpty) ||
                    (selectedType == "disease" && provider.pestDiseaseData.diseases.isEmpty)
                ? Center(
                    child: Text(
                    AppLocalization.of(context)
                        .getTranslatedValue("${selectedType}EmptyMessage")
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    textAlign: TextAlign.center,
                  ))
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
                        childAspectRatio: 3 / 4.5,
                      ),
                      itemBuilder: (context, index) {
                        final PestDiseaseObj item = selectedType == "pest"
                            ? provider.pestDiseaseData.pests[index]
                            : provider.pestDiseaseData.diseases[index];

                        return GestureDetector(
                          onTap: () {
                            Utils.model(
                              context,
                              PestAndDiseaseScreen(
                                selectedPestDisease: item,
                                useViewModel: provider,
                              ),
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
                                  borderRadius:
                                      const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        item.carousel.isNotEmpty ? item.carousel[0].image : "",
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: double.infinity,
                                    placeholder: (context, url) => Skeleton(
                                      height: 150,
                                      width: double.infinity,
                                      radius: 12,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalization.of(context).locale.toString() == "en"
                                              ? item.nameEn
                                              : item.nameHi,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppLocalization.of(context).locale.toString() == "en"
                                              ? item.nameSciEn
                                              : item.nameSciHi,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
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
