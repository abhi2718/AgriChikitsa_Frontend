import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import '../../services/auth.dart';

class ProfilePicture extends HookWidget {
  final Function picImage;
  final Function captureImage;
  final AuthService authService;
  final defaultImage =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
  const ProfilePicture({
    super.key,
    required this.picImage,
    required this.captureImage,
    required this.authService,
  });
  @override
  Widget build(BuildContext context) {
    final user = User.fromJson(authService.userInfo["user"]);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const ParagraphText('Take a photo'),
                    onTap: () {
                      captureImage(context, authService);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const ParagraphText("Choose from gallery"),
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
      },
      child: Container(
        alignment: Alignment.bottomRight,
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          image: DecorationImage(
            fit: BoxFit.fill,
            image: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : NetworkImage(
                    defaultImage,
                  ),
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
      ),
    );
  }
}
