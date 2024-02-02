import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/color.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    this.icon,
  });
  final IconData? icon;
  final dynamic height;
  final dynamic width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Color(0xff114D1E),
                Color(0xff185616),
                Color(0xff218817),
              ]),
          borderRadius: BorderRadius.circular(15)),
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColor.whiteColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.whiteColor),
                ),
              ],
            )
          : Text(
              title,
              style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.whiteColor),
            ),
    );
  }
}
