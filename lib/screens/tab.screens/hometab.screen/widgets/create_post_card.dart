import 'package:agriChikitsa/widgets/card.widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: CustomCard(
          child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        height: dimension['height']! * 0.17,
        width: dimension['width'],
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      authService.userInfo['user']['profileImage'].toString()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: BaseText(
                    title: AppLocalizationsHi().whatsHappening,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.darkBlackColor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/image.png',
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/icons/gif.png',
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/icons/emoji.png',
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: dimension['width']! - 220,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: dimension['width']! - 280,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            useViewModel.goToCreatePostScreen(context);
                          },
                          child: BaseText(
                            title: AppLocalizationsHi().post,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
