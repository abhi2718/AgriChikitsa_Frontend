import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';

class ButtonTab extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ButtonTab({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppColor.notificationBgColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16, color: AppColor.darkBlackColor),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}
