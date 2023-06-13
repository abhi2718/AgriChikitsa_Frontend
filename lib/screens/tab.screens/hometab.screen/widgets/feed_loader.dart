import 'package:flutter/material.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';

class FeedLoader extends StatelessWidget {
  const FeedLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.darkBlackColor.withOpacity(0.011),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Skeleton(
                  height: 40,
                  width: 40,
                  radius: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(
                      height: 10,
                      width: dimension['width']! - 200,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Skeleton(
                      height: 7,
                      width: dimension['width']! - 250,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Skeleton(
              height: 250,
              width: dimension['width']!,
              radius: 0,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(
                  height: 30,
                  width: 30,
                  radius: 0,
                ),
                Skeleton(
                  height: 30,
                  width: 30,
                  radius: 0,
                ),
                Skeleton(
                  height: 30,
                  width: 30,
                  radius: 0,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Skeleton(
              height: 70,
              width: dimension['width']!,
              radius: 0,
            ),
            const SizedBox(
              height: 10,
            ),
            Skeleton(
              height: 40,
              width: dimension['width']!,
            ),
          ],
        ),
      ),
    );
  }
}
