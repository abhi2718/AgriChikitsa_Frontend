import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
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
  final ProfileViewModel profileViewModel;
  const JankariCard({Key? key, required this.jankari, required this.profileViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<JankariViewModel>(context, listen: false));
    return InkWell(
      onTap: () {
        useViewModel.updateStats(context, 'category', jankari.id);
        useViewModel.setCategory(jankari.id);
        useViewModel.getJankariSubCategory(context, jankari.id);
        Utils.model(
            context,
            SubCategoryContainer(
              profileViewModel: profileViewModel,
            ));
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
                  imageUrl: jankari.backgroundImage,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Skeleton(
                    height: dimension['height']! * 0.16,
                    width: dimension['width']!,
                    radius: 8,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: jankari.icon,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                          height: 50,
                          width: 50,
                          radius: 0,
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        width: 50,
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.only(right: 2, top: 2, bottom: 2),
                        width: dimension["width"]! - 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseText(
                              title: profileViewModel.locale["language"] == "en"
                                  ? jankari.name
                                  : jankari.hindiName,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.whiteColor,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              profileViewModel.locale["language"] == "en"
                                  ? jankari.description
                                  : jankari.hindiDescription,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.whiteColor,
                              ),
                              maxLines: 3,
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
