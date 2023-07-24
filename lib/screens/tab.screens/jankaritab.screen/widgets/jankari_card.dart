import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../model/jankari_card_modal.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../jankari_view_model.dart';
import 'jankari_subcategory.dart';

class JankariCard extends HookWidget {
  final JankariCategoryModal jankari;

  const JankariCard({
    Key? key,
    required this.jankari,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
    final backgroundImage = jankari.backgroundImage.split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    final iconImage = jankari.icon.split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];

    return InkWell(
      onTap: () {
        useViewModel.updateStats(context, 'category', jankari.id);
        useViewModel.setCategory(jankari.id);
        useViewModel.getJankariSubCategory(context, jankari.id);
        Utils.model(context, const SubCategoryContainer());
      },
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Card(
          child: SizedBox(
            height: 110,
            width: dimension['width']! - 20,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://d336izsd4bfvcs.cloudfront.net/$backgroundImage',
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Skeleton(
                    height: dimension['height']! * 0.16,
                    width: dimension['width']!,
                    radius: 8,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://d336izsd4bfvcs.cloudfront.net/$iconImage',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Skeleton(
                          height: 50,
                          width: 50,
                          radius: 0,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 50,
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: dimension["width"]! - 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseText(
                              title: jankari.hindiName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.whiteColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            BaseText(
                              title: jankari.hindiDescription,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
