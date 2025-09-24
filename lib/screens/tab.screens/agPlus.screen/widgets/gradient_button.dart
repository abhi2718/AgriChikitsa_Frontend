import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/color.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key,
      required this.height,
      required this.width,
      required this.title,
      this.icon,
      this.isLoading});
  final IconData? icon;
  final dynamic height;
  final dynamic width;
  final String title;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      width: isLoading ?? false ? width + 30 : width,
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
                isLoading ?? false
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColor.whiteColor,
                        ),
                      )
                    : const SizedBox.shrink(),
                isLoading ?? false
                    ? const SizedBox(
                        width: 8,
                      )
                    : const SizedBox.shrink(),
                Icon(
                  icon,
                  color: AppColor.whiteColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.whiteColor),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading ?? false
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColor.whiteColor,
                        ),
                      )
                    : const SizedBox.shrink(),
                isLoading ?? false
                    ? const SizedBox(
                        width: 22,
                      )
                    : const SizedBox.shrink(),
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.whiteColor),
                ),
              ],
            ),
    );
  }
}
