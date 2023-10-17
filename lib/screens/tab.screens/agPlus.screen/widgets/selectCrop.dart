import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/location.screen/getCurrentLocation.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/plotDetails.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';
import 'helper/cropItem.dart';

class CropSelection extends HookWidget {
  const CropSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    Future<bool> _onWillPop() async {
      Navigator.pop(context);
      Utils.model(context, GetCurrentLocation());
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseText(
                    title: AppLocalizations.of(context)!.selectyourcrophi,
                    style: TextStyle(fontSize: 26)),
                Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    height: dimension["height"]! * 0.90,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: dimension['height']! * 0.0011,
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16),
                      children: [
                        ...provider.cropList
                            .map((e) => CropItem(crop: e))
                            .toList(),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            if (useViewModel.selectedCrop.isEmpty) {
              Utils.toastMessage("कृपया अपनी फसल चुने");
            } else {
              Navigator.pop(context);
              Utils.model(context, const PlotDetails());
            }
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            color: AppColor.extraDark,
          ),
        ),
      ),
    );
  }
}
