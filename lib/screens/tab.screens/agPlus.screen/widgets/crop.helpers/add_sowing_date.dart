import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddSowingDate extends HookWidget {
  final String fieldId;
  final bool isFromCropCard;
  const AddSowingDate({super.key, required this.fieldId, this.isFromCropCard = false});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    Future<bool> onWillPop() async {
      Navigator.pop(context);
      return true;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.setSowingDateFields();
      });
      return null;
    }, [useViewModel.selectedPlot]);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.lightColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).getTranslatedValue("addSowingDateAppBar").toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isFromCropCard
                      ? IgnorePointer(
                          ignoring: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: TextField(
                              enabled: false, // also prevents autofill features
                              controller: useViewModel.fieldSizecontroller,
                              cursorColor: Colors.transparent,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.grey), // dimmed text
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context)
                                    .getTranslatedValue("enterPlotArea")
                                    .toString(),
                                filled: true,
                                fillColor: Colors.grey.shade50, // light grey background
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  isFromCropCard
                      ? Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: dimension['height']! * 0.075,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade50,
                            ),
                            child: DropdownButton<String>(
                              underline: Container(),
                              isExpanded: true,
                              hint: BaseText(
                                title: AppLocalization.of(context)
                                    .getTranslatedValue("enterAreaUnit")
                                    .toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              value: provider.getLocalizedUnit(provider.areaUnit, context),
                              alignment: AlignmentDirectional.centerStart,
                              items: [
                                AppLocalization.of(context).getTranslatedValue("acre").toString(),
                                AppLocalization.of(context).getTranslatedValue("hectare").toString()
                              ].map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: BaseText(
                                    title: value,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                              onChanged: null,
                              disabledHint: BaseText(
                                title: provider.getLocalizedUnit(provider.areaUnit, context) ??
                                    AppLocalization.of(context)
                                        .getTranslatedValue("enterAreaUnit")
                                        .toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        })
                      : const SizedBox.shrink(),
                  Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                    return InkWell(
                      onTap: () => useViewModel.selectDate(context),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: dimension['height']! * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.event,
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              provider.sowingDate == null
                                  ? AppLocalization.of(context)
                                      .getTranslatedValue("enterSowingDate")
                                      .toString()
                                  : DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                      provider.sowingDate.toLocal().toString().split(' ')[0])),
                              // "Add Sowing Date",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                    return provider.sowingDate == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: TextField(
                              controller: provider.varietyNameController,
                              cursorColor: AppColor.darkBlackColor,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(color: AppColor.darkBlackColor),
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context)
                                    .getTranslatedValue("cropVariety")
                                    .toString(),
                                filled: true,
                                fillColor: AppColor.whiteColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onTapOutside: (_) => FocusManager.instance.primaryFocus!.unfocus(),
                              onChanged: (_) => provider.setVarietyName(),
                              onEditingComplete: () => provider.setVarietyName(),
                              onSubmitted: (_) => provider.validateVarietyName(context),
                            ),
                          );
                  }),
                  Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                    return provider.sowingDate == null || provider.durations.isEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: dimension['height']! * 0.075,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: DropdownButton(
                              underline: Container(),
                              isExpanded: true,
                              hint: BaseText(
                                title: AppLocalization.of(context)
                                    .getTranslatedValue("cropDuration")
                                    .toString(),
                                style: const TextStyle(),
                              ),
                              value: provider.selectedDuration?['_id'],
                              alignment: AlignmentDirectional.centerStart,
                              items:
                                  provider.durations.map<DropdownMenuItem<String>>((dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value["_id"],
                                  child: BaseText(
                                    title: AppLocalization.of(context).locale.toString() == "en"
                                        ? value["duration_en"]
                                        : value["duration_hi"],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (selectedId) {
                                if (selectedId != null) {
                                  final selected =
                                      provider.durations.firstWhere((d) => d["_id"] == selectedId);
                                  provider.setDuration(selected);
                                }
                              },
                            ),
                          );
                  }),
                  Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                    return InkWell(
                      onTap: () {
                        provider.sowingDateLoader
                            ? null
                            : useViewModel.addSowingDate(context, fieldId, isFromCropCard);
                      },
                      child: GradientButton(
                          isLoading: provider.sowingDateLoader,
                          height: dimension['height']! * 0.07,
                          width: dimension['width']! * 0.3,
                          title: AppLocalization.of(context).getTranslatedValue("save").toString()),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
