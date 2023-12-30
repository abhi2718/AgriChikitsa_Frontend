import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/crop_details.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/plot_details.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/category_button.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';
import '../helper/crop_item.dart';

class CropSelection extends HookWidget {
  const CropSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    Future<bool> onWillPop() async {
      Navigator.pop(context);
      Utils.model(context, const PlotDetails());
      return true;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: BaseText(
              title:
                  AppLocalization.of(context).getTranslatedValue("selectYourCropTitle").toString(),
              style: const TextStyle()),
        ),
        body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 18, top: 16, bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...provider.cropCategoriesList.map((category) {
                        return CategoryButton(
                          profileViewModel: profileViewModel,
                          category: category,
                          onTap: () {
                            provider.setActiveState(context, category, category.isActive);
                          },
                          provider: provider,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: provider.getCropListLoader
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.extraDark,
                            ),
                          )
                        : provider.cropList.isEmpty
                            ? Center(
                                child: Text(AppLocalization.of(context)
                                    .getTranslatedValue("noCropCategoryText")
                                    .toString()),
                              )
                            : GridView(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: dimension['height']! * 0.00111,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                                children: [
                                  ...provider.cropList
                                      .map((e) => CropItem(
                                            crop: e,
                                            profileViewModel: profileViewModel,
                                          ))
                                      .toList(),
                                ],
                              ),
                  );
                }),
              )
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            if (useViewModel.selectedCrop.isEmpty) {
              Utils.toastMessage(
                  AppLocalization.of(context).getTranslatedValue("warningSelectCrop").toString());
            } else {
              Navigator.pop(context);
              Utils.model(context, const CropDetails());
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
