import 'dart:async';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/select_crop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../ag_plus_view_model.dart';

class CropDetails extends StatelessWidget {
  const CropDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    Future<bool> onWillPop() async {
      Navigator.pop(context);
      Utils.model(context, const CropSelection());
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
            AppLocalization.of(context).getTranslatedValue("cropDetailsTitle").toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: useViewModel.fieldSizecontroller,
                cursorColor: AppColor.darkBlackColor,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: AppColor.darkBlackColor),
                decoration: InputDecoration(
                  hintText:
                      AppLocalization.of(context).getTranslatedValue("enterPlotArea").toString(),
                  filled: true,
                  fillColor: AppColor.whiteColor,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                ),
                onTapOutside: (_) => FocusManager.instance.primaryFocus!.unfocus(),
                onEditingComplete: () => useViewModel.setFieldSize(),
                onSubmitted: (_) => useViewModel.validateFieldSize(context),
              ),
            ),
            Consumer<AGPlusViewModel>(builder: (context, provider, child) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          .getTranslatedValue("enterAreaUnit")
                          .toString(),
                      style: const TextStyle(),
                    ),
                    value: provider.areaUnit.isEmpty ? null : provider.areaUnit,
                    alignment: AlignmentDirectional.centerStart,
                    items: [
                      AppLocalization.of(context).getTranslatedValue("acre").toString(),
                      AppLocalization.of(context).getTranslatedValue("hectare").toString()
                    ].map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: BaseText(
                          title: value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      provider.setAreaUnit(value);
                    }),
              );
            }),
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
            InkWell(
              onTap: () {
                useViewModel.createPlot(context);
              },
              child: GradientButton(
                  height: dimension['height']! * 0.07,
                  width: dimension['width']! * 0.3,
                  title: AppLocalization.of(context).getTranslatedValue("save").toString()),
            )
          ],
        ),
      ),
    );
  }
}
