import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/select_crop_model.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';

class CropItem extends StatelessWidget {
  const CropItem({
    super.key,
    required this.crop,
    required this.profileViewModel,
  });
  final SelectCrop crop;
  final ProfileViewModel profileViewModel;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    return Consumer<AGPlusViewModel>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () => useViewModel.setSelectedCrop(context, crop),
          child: Container(
            decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(offset: Offset(0, 2), color: Colors.grey)]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: dimension['height']! * 0.12,
                  child: Stack(fit: StackFit.expand, children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      backgroundImage: CachedNetworkImageProvider(
                        crop.backgroundImage,
                      ),
                    ),
                    crop.isSelected
                        ? Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
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
                  height: 8,
                ),
                Text(
                  AppLocalization.of(context).locale.toString() == "en" ? crop.name : crop.name_hi,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


// CachedNetworkImage(
//                             imageUrl: crop.backgroundImage,
//                             progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
//                               height: dimension["height"]! * 0.125,
//                               width: dimension["width"]! * 0.235,
//                               radius: 100,
//                             ),
//                             errorWidget: (context, url, error) => const Icon(Icons.error),
//                             width: 40,
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),