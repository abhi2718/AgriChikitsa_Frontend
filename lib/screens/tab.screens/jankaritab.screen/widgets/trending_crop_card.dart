import 'package:flutter/material.dart';

import '../../../../res/color.dart';

class TrendingCropCard extends StatelessWidget {
  const TrendingCropCard(
      {super.key,
      required this.dimension,
      required this.title,
      required this.url,
      required this.onTap});
  final dynamic dimension;
  final String title;
  final String url;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 4),
        height: dimension['height']! * 0.22,
        width: dimension['width']! * 0.28,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(offset: Offset(0, 2), color: Colors.grey)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppColor.extraDark,
              backgroundImage: NetworkImage(url),
              radius: (dimension['height']! * 0.22) * 0.22,
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
