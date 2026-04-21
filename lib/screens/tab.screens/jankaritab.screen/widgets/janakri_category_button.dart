import 'package:agriChikitsa/model/jankari_card_modal.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../res/color.dart';

class JankariSubCategoryButton extends StatelessWidget {
  final JankariCategoryModal category;
  final Function()? onTap;
  final ProfileViewModel profileViewModel;
  const JankariSubCategoryButton(
      {super.key, required this.category, required this.onTap, required this.profileViewModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<JankariViewModel>(builder: (context, provider, child) {
      return SizedBox(
        height: 30,
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            decoration: BoxDecoration(
              color: provider.selectedCategory == category.id ? const Color(0xff138808) : null,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: provider.selectedCategory == category.id
                    ? AppColor.darkColor
                    : AppColor.darkColor,
                width: category.isActive ? 1 : 1,
              ),
            ),
            child: Center(
              child: Text(
                profileViewModel.locale["language"] == "en" ? category.name : category.hindiName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: provider.selectedCategory == category.id
                      ? AppColor.whiteColor
                      : AppColor.darkBlackColor,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
