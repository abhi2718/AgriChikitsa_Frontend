import 'package:flutter/material.dart';

import '../../../../model/category_model.dart';
import '../../../../res/color.dart';

class CategoryButton extends StatelessWidget {
  final Category category;
  final Function()? onTap;
  const CategoryButton(
      {super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: category.isActive ? AppColor.darkColor : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: category.isActive ? AppColor.darkColor : AppColor.darkColor,
            width: category.isActive ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            category.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: category.isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
