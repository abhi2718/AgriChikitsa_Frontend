import 'dart:developer';

import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/medicine.screen/medicine_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/medicine.screen/medicine_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weedProtection.screen/widgets/button_tab.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weedProtection.screen/widgets/weed_carousel.dart';
import 'package:agriChikitsa/screens/tab.screens/textToSpeech/audio_play_view_model.dart';
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
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<AGPlusViewModel>(context, listen: false));
    final audioViewModel =
        useMemoized(() => Provider.of<AudioPlayerViewModel>(context, listen: false));
    final medicineViewModel =
        useMemoized(() => Provider.of<MedicineViewModel>(context, listen: false));
    final beforeExpanded = useState(false);
    final afterExpanded = useState(false);
    useEffect(() {
      medicineViewModel.reinitialize();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.getWeedProtectionData(
            context, useViewModel.selectedPlot.cropId, selectedWeedType, medicineViewModel);
        audioViewModel.reinitalize();
      });
      return null;
    }, []);
    return WillPopScope(
      onWillPop: () async {
        audioViewModel.stop();
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
              audioViewModel.stop();
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
                  if (provider.selectedAdvisory!.advisoryType == "organic") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final locale = AppLocalization.of(context).locale.toString();
                      if (locale == "en" && provider.selectedAdvisory!.audioBeforeEn.isNotEmpty) {
                        audioViewModel.setAudioUrl(provider.selectedAdvisory!.audioBeforeEn);
                      } else if (locale == "hi" &&
                          provider.selectedAdvisory!.audioBeforeHi.isNotEmpty) {
                        audioViewModel.setAudioUrl(provider.selectedAdvisory!.audioBeforeHi);
                      } else {
                        audioViewModel.setAudioUrl("");
                      }
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
                        WeedCarousel(images: provider.selectedAdvisory!.imagesBefore),
                        if (provider.selectedAdvisory!.advisoryType == "organic")
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
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    color: AppColor.whiteColor,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Consumer<AudioPlayerViewModel>(
                                          builder: (context, audioProvider, _) {
                                            final hasUrl = audioProvider.audioUrl.isNotEmpty;
                                            final isLoading = audioProvider.isLoading;
                                            final isPlaying = audioProvider.isPlaying;
                                            final isPaused = audioProvider.isPaused;

                                            String buttonText;
                                            if (isLoading) {
                                              buttonText = AppLocalization.of(context)
                                                  .getTranslatedValue("loadingAudio")
                                                  .toString();
                                            } else if (isPlaying) {
                                              buttonText = AppLocalization.of(context)
                                                  .getTranslatedValue("pauseAudio")
                                                  .toString();
                                            } else {
                                              buttonText = AppLocalization.of(context)
                                                  .getTranslatedValue("playAudio")
                                                  .toString();
                                            }

                                            return !hasUrl
                                                ? const SizedBox.shrink()
                                                : ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColor.tabIconColor,
                                                      foregroundColor: Colors.white,
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 4),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                    ),
                                                    onPressed: isLoading
                                                        ? null
                                                        : () {
                                                            if (isPlaying) {
                                                              audioProvider.pause();
                                                            } else if (isPaused) {
                                                              audioProvider.resume();
                                                            } else {
                                                              audioProvider.play(context);
                                                            }
                                                          },
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        if (isLoading)
                                                          const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                        else
                                                          Icon(
                                                            isPlaying
                                                                ? Icons.pause
                                                                : Icons.play_arrow,
                                                            color: Colors.white,
                                                          ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          buttonText,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        HtmlWidget(
                                            AppLocalization.of(context).locale.toString() == "en"
                                                ? provider.selectedAdvisory!.advisoryBeforeEn
                                                : provider.selectedAdvisory!.advisoryBeforeHi),
                                        Consumer<MedicineViewModel>(
                                            builder: (context, provider, _) {
                                          return Column(
                                            children: provider.isManageListLoading
                                                ? List.generate(
                                                    3,
                                                    (index) => Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            vertical: 4.0),
                                                        child: Skeleton(
                                                            height: dimension["height"]! * 0.1,
                                                            width: dimension["width"]!)),
                                                  )
                                                : List.generate(
                                                    provider.weedManageList.length,
                                                    (index) => Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: ButtonTab(
                                                        text: provider.weedManageList[index][
                                                            AppLocalization.of(context)
                                                                        .locale
                                                                        .toString() ==
                                                                    "en"
                                                                ? "nameEn"
                                                                : "nameHi"],
                                                        onPressed: () => Utils.model(
                                                            context,
                                                            MedicineScreen(
                                                                showCalculator: false,
                                                                method: provider
                                                                    .weedManageList[index])),
                                                      ),
                                                    ),
                                                  ),
                                          );
                                        }),
                                      ],
                                    ))
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
                                      audioViewModel.reinitalize();
                                      final locale = AppLocalization.of(context).locale.toString();
                                      if (locale == "en" &&
                                          provider.selectedAdvisory!.audioBeforeEn.isNotEmpty) {
                                        audioViewModel
                                            .setAudioUrl(provider.selectedAdvisory!.audioBeforeEn);
                                      } else if (locale == "hi" &&
                                          provider.selectedAdvisory!.audioBeforeHi.isNotEmpty) {
                                        audioViewModel
                                            .setAudioUrl(provider.selectedAdvisory!.audioBeforeHi);
                                      } else {
                                        audioViewModel.setAudioUrl("");
                                      }
                                    } else {
                                      audioViewModel.stop();
                                    }
                                  },
                                  children: [
                                    Consumer<AudioPlayerViewModel>(
                                      builder: (context, audioProvider, child) {
                                        final hasUrl = audioProvider.audioUrl.isNotEmpty;
                                        if (hasUrl) {
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: audioProvider.isLoading
                                                ? Container(
                                                    width: 40,
                                                    height: 40,
                                                    margin:
                                                        const EdgeInsets.only(left: 12, bottom: 8),
                                                    decoration: const BoxDecoration(
                                                      color: AppColor.darkColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: AppColor.whiteColor,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(left: 12, bottom: 8),
                                                    decoration: const BoxDecoration(
                                                      color: AppColor.darkColor,
                                                      shape: BoxShape.circle, // round button
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        audioProvider.isPlaying
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                        color: Colors.white, // white icon
                                                      ),
                                                      onPressed: () {
                                                        if (audioProvider.isPlaying) {
                                                          audioProvider.pause();
                                                        } else if (audioProvider.isPaused) {
                                                          audioProvider.resume();
                                                        } else {
                                                          audioProvider.play(context);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          HtmlWidget(
                                              AppLocalization.of(context).locale.toString() == "en"
                                                  ? provider.selectedAdvisory!.advisoryBeforeEn
                                                  : provider.selectedAdvisory!.advisoryBeforeHi),
                                          Consumer<MedicineViewModel>(
                                              builder: (context, provider, _) {
                                            final filteredList = provider.weedManageList
                                                .where((item) => item["type"] == "before")
                                                .toList();
                                            return Column(
                                              children: provider.isManageListLoading
                                                  ? List.generate(
                                                      3,
                                                      (index) => Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                          child: Skeleton(
                                                              height: dimension["height"]! * 0.1,
                                                              width: dimension["width"]!)),
                                                    )
                                                  : List.generate(
                                                      filteredList.length,
                                                      (index) => Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            vertical: 4.0),
                                                        child: ButtonTab(
                                                          text: filteredList[index][
                                                              AppLocalization.of(context)
                                                                          .locale
                                                                          .toString() ==
                                                                      "en"
                                                                  ? "nameEn"
                                                                  : "nameHi"],
                                                          onPressed: () => Utils.model(
                                                              context,
                                                              MedicineScreen(
                                                                  method: filteredList[index])),
                                                        ),
                                                      ),
                                                    ),
                                            );
                                          }),
                                        ],
                                      ),
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
                                      audioViewModel.reinitalize();
                                      final locale = AppLocalization.of(context).locale.toString();
                                      if (locale == "en" &&
                                          provider.selectedAdvisory!.audioAfterEn.isNotEmpty) {
                                        audioViewModel
                                            .setAudioUrl(provider.selectedAdvisory!.audioAfterEn);
                                      } else if (locale == "hi" &&
                                          provider.selectedAdvisory!.audioAfterHi.isNotEmpty) {
                                        audioViewModel
                                            .setAudioUrl(provider.selectedAdvisory!.audioAfterHi);
                                      } else {
                                        audioViewModel.setAudioUrl("");
                                      }
                                    } else {
                                      audioViewModel.stop();
                                    }
                                  },
                                  children: [
                                    Consumer<AudioPlayerViewModel>(
                                      builder: (context, audioProvider, child) {
                                        final hasUrl = audioProvider.audioUrl.isNotEmpty;
                                        if (hasUrl) {
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: audioProvider.isLoading
                                                ? Container(
                                                    width: 40,
                                                    height: 40,
                                                    margin:
                                                        const EdgeInsets.only(left: 12, bottom: 8),
                                                    decoration: const BoxDecoration(
                                                      color: AppColor.darkColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: AppColor.whiteColor,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(left: 12, bottom: 8),
                                                    decoration: const BoxDecoration(
                                                      color: AppColor.darkColor,
                                                      shape: BoxShape.circle, // round button
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        audioProvider.isPlaying
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                        color: Colors.white, // white icon
                                                      ),
                                                      onPressed: () {
                                                        if (audioProvider.isPlaying) {
                                                          audioProvider.pause();
                                                        } else if (audioProvider.isPaused) {
                                                          audioProvider.resume();
                                                        } else {
                                                          audioProvider.play(context);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            HtmlWidget(
                                                AppLocalization.of(context).locale.toString() ==
                                                        "en"
                                                    ? provider.selectedAdvisory!.advisoryAfterEn
                                                    : provider.selectedAdvisory!.advisoryAfterHi),
                                            Consumer<MedicineViewModel>(
                                                builder: (context, provider, _) {
                                              final filteredList = provider.weedManageList
                                                  .where((item) => item["type"] == "after")
                                                  .toList();
                                              return Column(
                                                children: provider.isManageListLoading
                                                    ? List.generate(
                                                        3,
                                                        (index) => Padding(
                                                            padding: const EdgeInsets.symmetric(
                                                                vertical: 4.0),
                                                            child: Skeleton(
                                                                height: dimension["height"]! * 0.1,
                                                                width: dimension["width"]!)),
                                                      )
                                                    : List.generate(
                                                        filteredList.length,
                                                        (index) => Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                          child: ButtonTab(
                                                            text: filteredList[index][
                                                                AppLocalization.of(context)
                                                                            .locale
                                                                            .toString() ==
                                                                        "en"
                                                                    ? "nameEn"
                                                                    : "nameHi"],
                                                            onPressed: () => Utils.model(
                                                                context,
                                                                MedicineScreen(
                                                                    method: filteredList[index])),
                                                          ),
                                                        ),
                                                      ),
                                              );
                                            }),
                                          ],
                                        )),
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
                    child: Image.asset(
                      "assets/images/organic_kharpatwar.jpeg",
                      errorBuilder: (context, url, error) => const Icon(Icons.error),
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
                    child: Image.asset(
                      "assets/images/chemical_kharpatwar.jpeg",
                      errorBuilder: (context, url, error) => const Icon(Icons.error),
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
