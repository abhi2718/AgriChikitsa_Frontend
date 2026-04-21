import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomChatButton extends StatelessWidget {
  const CustomChatButton(
      {super.key, required this.text, required this.isSelected, this.isCrops = false});
  final String text;
  final bool isSelected;
  final bool isCrops;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCrops ? 100 : null,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        right: 8,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? const Color(0xff4BA859) : AppColor.whiteColor,
          border: Border.all(color: AppColor.darkBlackColor)),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.whiteColor : AppColor.darkBlackColor,
            fontSize: 13),
      ),
    );
  }
}
