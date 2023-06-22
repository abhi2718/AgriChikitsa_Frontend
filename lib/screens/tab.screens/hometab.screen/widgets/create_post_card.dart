import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:agriChikitsa/widgets/card.widgets/card.dart';
import 'package:flutter/material.dart';
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
        horizontal: 8,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(authService.userInfo['user']
                            ['profileImage']
                        .toString()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BaseText(
                        title: "What's Happening?",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColor.darkBlackColor)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomElevatedButton(
                title: "Create Post",
                onPress: () => useViewModel.goToCreatePostScreen(context),
                width: dimension['width']! - 230,
                height: 50,
              ),
            )
          ],
        ),
      )),
    );
  }
}
