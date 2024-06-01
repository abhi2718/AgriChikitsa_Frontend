import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:flutter/material.dart';
import '../../../../res/color.dart';

class CategoryButton extends StatelessWidget {
  final dynamic category;
  final Function()? onTap;
  final dynamic provider;
  final ProfileViewModel profileViewModel;
  const CategoryButton(
      {super.key,
      required this.category,
      required this.onTap,
      required this.provider,
      required this.profileViewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          decoration: BoxDecoration(
            color: provider.currentSelectedCategory == category.id ? AppColor.darkColor : null,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: provider.currentSelectedCategory == category.id
                  ? AppColor.darkColor
                  : AppColor.darkBlackColor,
              width: category.isActive ? 0 : 1,
            ),
          ),
          child: Center(
            child: Text(
              profileViewModel.locale["language"] == "en" ? category.name : category.nameHi,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color:
                    provider.currentSelectedCategory == category.id ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
