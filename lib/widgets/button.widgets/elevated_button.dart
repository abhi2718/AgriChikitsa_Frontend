import 'package:flutter/material.dart';
import '../../res/color.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  final double width;
  final double height;
  const CustomElevatedButton({
    super.key,
    required this.title,
    this.loading = false,
    this.width = 200,
    this.height = 54,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: loading ? null : onPress,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.darkColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: loading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    )
                  ],
                )
              : Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
