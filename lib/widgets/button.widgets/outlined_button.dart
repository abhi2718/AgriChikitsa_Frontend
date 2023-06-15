import 'package:flutter/material.dart';
import '../../res/color.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  final double width;
  const CustomOutlinedButton({
    super.key,
    required this.title,
    this.loading = false,
    this.width = 200,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onPress,
      child: Container(
        width: width,
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.darkColor,
          ),
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
                        color: AppColor.darkColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColor.darkColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                      ),
                    )
                  ],
                )
              : Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.darkColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                  ),
                ),
        ),
      ),
    );
  }
}
