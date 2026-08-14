import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/pestAndDisease.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/helper/pest_medicine_carousel.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/helper/pest_medicine_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:agriChikitsa/widgets/html_render_with_audio.dart';
import 'package:provider/provider.dart';

class PestMedicineScreen extends HookWidget {
  const PestMedicineScreen({super.key, required this.selectedSolution});
  final SolutionRef selectedSolution;

  void dosageCalculatorModal(BuildContext context, Map<String, double> dimension) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final locale = AppLocalization.of(context).locale.toString();

        return Dialog(
          backgroundColor: AppColor.notificationBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Consumer<PestMedicineViewModel>(builder: (context, provider, _) {
                  return AbsorbPointer(
                    absorbing: provider.isCalculating,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("calculateSizeTitle")
                              .toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          enabled: !provider.isCalculating,
                          controller: provider.plotSizeController,
                          cursorColor: AppColor.darkBlackColor,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: AppColor.darkBlackColor),
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context)
                                .getTranslatedValue("calculateSizeDescription")
                                .toString(),
                            filled: true,
                            fillColor: AppColor.whiteColor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                          onChanged: (_) => provider.setPlotSize(),
                          onEditingComplete: () => provider.setPlotSize(),
                          onSubmitted: (_) => provider.validatePlotSize(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("enterAreaUnit")
                              .toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: -8,
                          children: provider.areaUnits.map((unit) {
                            final text = locale == "en" ? unit["textEn"] : unit["textHi"];
                            return SizedBox(
                              width: 120,
                              child: RadioListTile<String>(
                                activeColor: AppColor.extraDark,
                                title: Text(
                                  text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                value: unit["value"],
                                groupValue: provider.selectedAreaUnitValue,
                                onChanged: provider.isCalculating
                                    ? null
                                    : (val) => provider.setSelectedAreaUnit(val!),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalization.of(context).getTranslatedValue("pumpSizeText").toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: -8,
                          children: provider.pumpSizes.map((pump) {
                            final text = locale == "en" ? pump["textEn"] : pump["textHi"];
                            return SizedBox(
                              width: 120,
                              child: RadioListTile<String>(
                                activeColor: AppColor.extraDark,
                                title: Text(
                                  text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                value: pump["value"],
                                groupValue: provider.selectedPumpSizeValue,
                                onChanged: provider.isCalculating
                                    ? null
                                    : (val) => provider.setSelectedPumpSize(val!),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: provider.isCalculating
                              ? null
                              : () {
                                  if (provider.validateDosageInputs(context)) {
                                    provider
                                        .calculateDosage(context, selectedSolution.id)
                                        .then((result) {
                                      Navigator.pop(context);
                                      dosageResultPopup(context, result);
                                    });
                                  }
                                },
                          child: GradientButton(
                            height: dimension["height"]! * 0.08,
                            width: dimension["width"],
                            isLoading: provider.isCalculating,
                            title: AppLocalization.of(context)
                                .getTranslatedValue("calculateBtnTitle")
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  void dosageResultPopup(BuildContext context, dynamic result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Center(
                  child: Text(
                      AppLocalization.of(context).getTranslatedValue("suggestion").toString(),
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.extraDark)),
                ),
                const SizedBox(height: 10),
                Text(
                    AppLocalization.of(context).locale.toString() == "en"
                        ? result["data"]["messages"]["message1_en"]
                        : result["data"]["messages"]["message1_hi"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(
                    AppLocalization.of(context).locale.toString() == "en"
                        ? result["data"]["messages"]["message2_en"]
                        : result["data"]["messages"]["message2_hi"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<PestMedicineViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.reinitializeMedicine();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.getSolutionsData(context, selectedSolution.id);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            AppLocalization.of(context).locale.toString() == "en"
                ? selectedSolution.nameEn
                : selectedSolution.nameHi,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
            overflow: TextOverflow.visible,
          ),
        ),
        body: Consumer<PestMedicineViewModel>(builder: (context, provider, _) {
          return provider.isSolutionLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                )
              : provider.solution == null
                  ? Center(
                      child: Text(
                      AppLocalization.of(context).getTranslatedValue("noDataFound").toString(),
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: provider.solution!.chemicalSolutionCarousel.isEmpty ? 0 : 32,
                          ),
                          provider.solution!.chemicalSolutionCarousel.isEmpty
                              ? SizedBox.shrink()
                              : PestMedicineCarousel(
                                  chemicals: provider.solution!.chemicalSolutionCarousel,
                                  pestMedicineViewModel: provider),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
                            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColor.notificationBgColor,
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: Offset(
                                      0,
                                      8,
                                    ),
                                  ),
                                ]),
                            child: HtmlRenderWithAudio(
                                htmlContent: AppLocalization.of(context).locale.toString() == "en"
                                    ? provider.solution!.contentEn
                                    : provider.solution!.contentHi),
                          ),
                          !provider.solution!.showCalculator
                              ? SizedBox.shrink()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 14, right: 14, bottom: 22),
                                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(255, 90, 124, 61),
                                          blurRadius: 12,
                                          spreadRadius: 0,
                                          offset: Offset(
                                            1,
                                            4,
                                          ),
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("dosageCardTitle")
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColor.darkBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("dosageCardDescription")
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColor.darkBlackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      InkWell(
                                        onTap: () => dosageCalculatorModal(context, dimension),
                                        child: GradientButton(
                                          height: dimension["height"]! * 0.08,
                                          width: dimension["width"],
                                          title: AppLocalization.of(context)
                                              .getTranslatedValue("dosageBtnTitle")
                                              .toString(),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    );
        }));
  }
}
