import 'package:agriChikitsa/model/jankari_card_modal.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../res/color.dart';

class JankariSubCategoryButton extends StatelessWidget {
  final JankariCategoryModal category;
  final Function()? onTap;
  const JankariSubCategoryButton(
      {super.key, required this.category, required this.onTap});

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
              color: provider.selectedCategory == category.id
                  ? AppColor.darkColor
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: provider.selectedCategory == category.id
                    ? AppColor.darkColor
                    : AppColor.darkColor,
                width: category.isActive ? 1 : 1,
              ),
            ),
            child: Center(
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: provider.selectedCategory == category.id
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
