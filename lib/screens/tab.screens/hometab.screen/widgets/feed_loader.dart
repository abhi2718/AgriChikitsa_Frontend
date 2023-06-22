import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Skeleton(
                    height: 40,
                    width: 40,
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(
                        height: 13,
                        width: dimension['width']! - 250,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Skeleton(
                        height: 10,
                        width: dimension['width']! - 300,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Skeleton(
              height: 240,
              width: dimension['width']! - 16,
              radius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeleton(
                    height: 27,
                    width: 30,
                    radius: 0,
                  ),
                  Skeleton(
                    height: 27,
                    width: 30,
                    radius: 0,
                  ),
                  Skeleton(
                    height: 27,
                    width: 30,
                    radius: 0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Skeleton(
                height: 72,
                width: dimension['width']!,
                radius: 0,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Skeleton(
                height: 40,
                width: dimension['width']!,
                radius: 20,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
