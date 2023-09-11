import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';

class PlotDetails extends HookWidget {
  const PlotDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: BaseText(
                    title: "Enter Plot Details",
                    style: TextStyle(fontSize: 22, color: Colors.black87)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: useViewModel.fieldNamecontroller,
                  cursorColor: AppColor.darkBlackColor,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppColor.darkBlackColor),
                  decoration: InputDecoration(
                    hintText: "Enter name of Plot",
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onEditingComplete: () => useViewModel.setFieldName(),
                  onSubmitted: (_) => useViewModel.validateFieldName(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  focusNode: useViewModel.plotSizeFocusNode,
                  controller: useViewModel.fieldSizecontroller,
                  cursorColor: AppColor.darkBlackColor,
                  style: const TextStyle(color: AppColor.darkBlackColor),
                  decoration: InputDecoration(
                    hintText: "Enter Size of plot",
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onEditingComplete: () => useViewModel.setFieldSize(),
                  onSubmitted: (_) => useViewModel.validateFieldSize(context),
                ),
              ),
              InkWell(
                onTap: () {
                  useViewModel.checkPlotDetails(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: dimension["height"]! * 0.075,
                  width: dimension["width"]! * 0.36,
                  decoration: BoxDecoration(
                      color: AppColor.extraDark,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                      child: BaseText(
                    title: "Submit",
                    style: TextStyle(color: AppColor.whiteColor, fontSize: 18),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
