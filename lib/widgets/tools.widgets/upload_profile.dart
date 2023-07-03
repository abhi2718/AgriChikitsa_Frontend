import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/edit_profile/edit_profile_view_model.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class ProfilePicture extends HookWidget {
  final Function picImage;
  final Function captureImage;
  final AuthService authService;
  const ProfilePicture({
    super.key,
    required this.picImage,
    required this.captureImage,
    required this.authService,
  });
  @override
  Widget build(BuildContext context) {
    final user = User.fromJson(authService.userInfo["user"]);
    final profileImage = user.profileImage!.split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    return GestureDetector(onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title:
                      ParagraphText(AppLocalizations.of(context)!.takePhotohi),
                  onTap: () {
                    captureImage(context, authService);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: ParagraphText(
                      AppLocalizations.of(context)!.chooseFromGalleryhi),
                  onTap: () {
                    picImage(context, authService);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }, child:
        Consumer<EditProfileViewModel>(builder: (context, provider, child) {
      return provider.imageLoading
          ? Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.lightColor),
              child: const Center(child: CircularProgressIndicator()),
            )
          : Container(
              alignment: Alignment.bottomRight,
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      'https://d336izsd4bfvcs.cloudfront.net/$profileImage'),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, right: 4),
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: AppColor.darkColor,
                ),
              ),
            );
    }));
  }
}
