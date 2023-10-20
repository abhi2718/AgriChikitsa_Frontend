import 'package:flutter/material.dart';

import '../../../../../../res/color.dart';
import '../../../../../../utils/utils.dart';

class WeatherCard extends StatelessWidget {
  WeatherCard({super.key, required this.title, required this.value, required this.imagePath});
  IconData imagePath;
  String title;
  String value;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return SingleChildScrollView(
      child: Container(
        height: dimension['height']! * 0.12,
        width: dimension['width']! * 0.40,
        decoration:
            BoxDecoration(color: AppColor.whiteColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              imagePath,
              size: 34,
              color: const Color(0xff3C6EEF),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, color: Color(0xff494343)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
