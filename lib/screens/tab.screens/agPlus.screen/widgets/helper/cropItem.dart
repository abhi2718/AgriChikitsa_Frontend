import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/select_crop_model.dart';
import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/skeleton/skeleton.dart';
import '../../agPlus_view_model.dart';

class CropItem extends StatelessWidget {
  CropItem({
    super.key,
    required this.crop,
  });
  SelectCrop crop;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    return Consumer<AGPlusViewModel>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () => useViewModel.setSelectedCrop(context, crop),
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: dimension["height"]! * 0.125,
                    width: dimension["width"]! * 0.235,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 1,
                            blurRadius: 8)
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Stack(fit: StackFit.expand, children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: crop.backgroundImage,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Skeleton(
                            height: dimension["height"]! * 0.125,
                            width: dimension["width"]! * 0.235,
                            radius: 100,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 40,
                          fit: BoxFit.cover,
                          height: 40,
                        ),
                      ),
                      crop.isSelected
                          ? Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.done,
                                    size: 36,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ]),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    crop.name,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
