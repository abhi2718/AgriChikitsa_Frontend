import 'dart:async';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChangeCropDuration extends StatelessWidget {
  final String fieldId;
  const ChangeCropDuration({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    Future<bool> onWillPop() async {
      Navigator.pop(context);
      Navigator.pop(context);
      return true;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.lightColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).getTranslatedValue("changeCrop").toString(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                        return Checkbox(
                          value: provider.notPlantedCheck,
                          onChanged: (bool? value) {
                            provider.setNotPlantedCheck(value);
                          },
                          activeColor: Colors.green,
                        );
                      }),
                      Text(
                        AppLocalization.of(context).getTranslatedValue("notPlantedYet").toString(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
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
                              value: provider.selectedDuration,
                              alignment: AlignmentDirectional.centerStart,
                              items: provider.durations
                                  .map<DropdownMenuItem<Map<String, dynamic>>>((dynamic value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: value,
                                  child: BaseText(
                                    title: value["duration"],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  provider.setDuration(value);
                                }
                              },
                            ),
                          );
                  }),
                  InkWell(
                    onTap: () {
                      useViewModel.changeCropFromField(context, fieldId);
                    },
                    child: GradientButton(
                        height: dimension['height']! * 0.07,
                        width: dimension['width']! * 0.3,
                        title: AppLocalization.of(context).getTranslatedValue("save").toString()),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
