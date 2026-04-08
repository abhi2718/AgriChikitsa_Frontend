import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/crop.helpers/add_sowing_date.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/select_crop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../model/plots.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';

class SelectedPlotDetails extends HookWidget {
  const SelectedPlotDetails({super.key, required this.selectedPlot});
  final Plots selectedPlot;

  void checkAndShowYieldDialogOnCropChange(
    BuildContext context,
    AGPlusViewModel useViewModel,
    Map<String, double> dimension,
  ) {
    if (useViewModel.selectedPlot.cropId == null ||
        !useViewModel.selectedPlot.isHarvesting ||
        useViewModel.selectedPlot.isYieldAdded) {
      return;
    }
    final locale = AppLocalization.of(context).locale.toString();

    showDialog(
      context: context,
      builder: (ctx) => Consumer<AGPlusViewModel>(builder: (context, provider, child) {
        return AlertDialog(
          title: provider.isYieldDataProcessing
              ? SizedBox.shrink()
              : Text(
                  AppLocalization.of(ctx).getTranslatedValue("yieldTitle").toString(),
                ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.isYieldDataProcessing
                ? [
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.extraDark,
                      ),
                    )
                  ]
                : [
                    TextField(
                      controller: provider.yieldController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText:
                            AppLocalization.of(ctx).getTranslatedValue("yieldError").toString(),
                        hintStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// Unit dropdown
                    DropdownButtonFormField<String>(
                      initialValue: provider.selectedYieldUnit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: provider.yieldUnits.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit.value,
                          child: Text(unit.getLabel(locale)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          provider.setSelectedYieldUnit(value);
                        }
                      },
                    ),
                  ],
          ),
          actions: provider.isYieldDataProcessing
              ? []
              : [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      AppLocalization.of(context).getTranslatedValue("no").toString(),
                      style: const TextStyle(color: AppColor.errorColor),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      provider.postYieldDataFromPopup(context, provider.selectedPlot.cropHistoryId,
                          isFromCropChangeCard: true);
                    },
                    child: GradientButton(
                      height: dimension['height']! * 0.07,
                      width: dimension['width']! * 0.2,
                      title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
                    ),
                  ),
                ],
        );
      }),
    );
  }

  void cropChangeDialog(
    BuildContext context,
    AGPlusViewModel useViewModel,
    Map<String, double> dimension,
  ) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(AppLocalization.of(context).getTranslatedValue("warningTitle").toString()),
        content: Text(
            AppLocalization.of(context).getTranslatedValue("changeCropWarningSubtitle").toString()),
        actions: [
          InkWell(
            onTap: () {
              useViewModel.fetchCropCategories(context);
              Utils.model(
                  context,
                  CropSelection(
                    isFromFieldScreen: true,
                    fieldId: useViewModel.selectedPlot.id,
                  ));
            },
            child: GradientButton(
              height: dimension['height']! * 0.06,
              width: dimension['width']! * 0.2,
              title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
            ),
          ),
          TextButton(
            child: Text(
              AppLocalization.of(context).getTranslatedValue("no").toString(),
              style: const TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<AGPlusViewModel>(context, listen: false));
    return GestureDetector(
      onTap: () {
        if (selectedPlot.cropId != null && selectedPlot.sowingDate == null) {
          Utils.model(
              context,
              AddSowingDate(
                fieldId: selectedPlot.id,
                isFromCropCard: true,
              ));
        } else if (selectedPlot.cropId == null) {
          useViewModel.fetchCropCategories(context);
          Utils.model(
              context,
              CropSelection(
                isFromFieldScreen: true,
                fieldId: useViewModel.selectedPlot.id,
                wasCropEmpty: true,
              ));
        } else if (selectedPlot.isHarvesting && !selectedPlot.isYieldAdded) {
          checkAndShowYieldDialogOnCropChange(context, useViewModel, dimension);
        } else {
          cropChangeDialog(context, useViewModel, dimension);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        height: dimension['height']! * 0.21,
        width: dimension['width']!,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: selectedPlot.cropImage ??
                    "https://images.unsplash.com/photo-1593738226658-f3e01177c3f0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                fit: BoxFit.cover,
                placeholder: (context, url) => Skeleton(
                  height: dimension['height']! * 0.21,
                  width: dimension['width']!,
                  radius: 12,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalization.of(context).locale.toString() == "en"
                        ? selectedPlot.cropName
                        : selectedPlot.cropNameHi,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500, fontSize: 28, color: AppColor.whiteColor),
                  ),
                  Text(
                    "${AppLocalization.of(context).getTranslatedValue("area").toString()} : ${selectedPlot.area}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500, fontSize: 18, color: AppColor.whiteColor),
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslatedValue("dateOfPlantation")
                            .toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: const Color(0xffFFDE41)),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        selectedPlot.sowingDate ??
                            AppLocalization.of(context)
                                .getTranslatedValue("notPlantedYet")
                                .toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500, fontSize: 12, color: AppColor.whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
