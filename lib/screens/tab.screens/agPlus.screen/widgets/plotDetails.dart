import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/selectCrop.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';

class PlotDetails extends HookWidget {
  const PlotDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.setAddFieldLoader(false);
    }, []);
    Future<bool> _onWillPop() async {
      if (useViewModel.addFieldLoader) {
        return false;
      }
      Navigator.pop(context);
      Utils.model(context, CropSelection());
      return true;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: AppColor.notificationBgColor,
          body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: BaseText(
                                title: AppLocalizations.of(context)!
                                    .fieldDetailshi,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black87)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: TextField(
                              controller: useViewModel.fieldNamecontroller,
                              cursorColor: AppColor.darkBlackColor,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  color: AppColor.darkBlackColor),
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.fieldNamehi,
                                filled: true,
                                fillColor: AppColor.whiteColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onEditingComplete: () =>
                                  useViewModel.setFieldName(),
                              onSubmitted: (_) =>
                                  useViewModel.validateFieldName(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: TextField(
                              focusNode: useViewModel.plotSizeFocusNode,
                              controller: useViewModel.fieldSizecontroller,
                              cursorColor: AppColor.darkBlackColor,
                              style: const TextStyle(
                                  color: AppColor.darkBlackColor),
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.fieldSizehi,
                                filled: true,
                                fillColor: AppColor.whiteColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              onEditingComplete: () =>
                                  useViewModel.setFieldSize(),
                              onSubmitted: (_) =>
                                  useViewModel.validateFieldSize(context),
                            ),
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
                                  color: AppColor.extraDark,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: BaseText(
                                title: AppLocalizations.of(context)!
                                    .continueTexthi,
                                style: TextStyle(
                                    color: AppColor.whiteColor, fontSize: 18),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (provider.addFieldLoader)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: AppColor.whiteColor),
                    ),
                  ),
              ],
            );
          }),
        ));
  }
}
