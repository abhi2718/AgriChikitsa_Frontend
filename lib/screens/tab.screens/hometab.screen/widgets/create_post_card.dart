import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../hometab_view_model.dart';

class CreatePostCard extends HookWidget {
  const CreatePostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);
    final profileImage = authService.userInfo['user']['profileImage'].split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          height: dimension['height']! * 0.16,
          width: dimension['width'],
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://d336izsd4bfvcs.cloudfront.net/$profileImage',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Skeleton(
                          height: 40,
                          width: 40,
                          radius: 0,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 40,
                        fit: BoxFit.cover,
                        height: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BaseText(
                        title: AppLocalizations.of(context)!.createPosthi,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColor.darkBlackColor)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 5, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: dimension['width']! * 0.30,
                    height: dimension['height']! * 0.055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        useViewModel.goToCreatePostScreen(context);
                      },
                      child: BaseText(
                        title: AppLocalizations.of(context)!.posthi,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
