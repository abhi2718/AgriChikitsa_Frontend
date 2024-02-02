import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

class PlotDetails extends HookWidget {
  const PlotDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {}, []);
    return Scaffold(
      backgroundColor: AppColor.lightColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("plotDeatilsTitle").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<AGPlusViewModel>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: useViewModel.fieldNamecontroller,
                  cursorColor: AppColor.darkBlackColor,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppColor.darkBlackColor),
                  decoration: InputDecoration(
                    hintText:
                        AppLocalization.of(context).getTranslatedValue("enterPlotName").toString(),
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                  onEditingComplete: () => useViewModel.setFieldName(),
                  onSubmitted: (_) => useViewModel.validateFieldName(context),
                ),
              ),
              Container(
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
                          .getTranslatedValue("enterSoilType")
                          .toString(),
                      style: const TextStyle(),
                    ),
                    value: provider.soilType.isEmpty ? null : provider.soilType,
                    alignment: AlignmentDirectional.centerStart,
                    items: [
                      AppLocalization.of(context).getTranslatedValue("blackSoil").toString(),
                      AppLocalization.of(context).getTranslatedValue("redSoil").toString()
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
                      provider.setSoilType(value);
                    }),
              ),
              InkWell(
                onTap: () {
                  useViewModel.checkPlotDetails(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: dimension["height"]! * 0.075,
                  width: dimension["width"]! * 0.36,
                  decoration: BoxDecoration(
                      color: AppColor.extraDark, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: BaseText(
                    title: AppLocalization.of(context).getTranslatedValue("save").toString(),
                    style: const TextStyle(color: AppColor.whiteColor, fontSize: 18),
                  )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
