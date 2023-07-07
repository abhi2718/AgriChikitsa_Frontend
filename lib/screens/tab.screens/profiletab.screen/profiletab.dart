import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/widgets/delete_alert.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../widgets/skeleton/skeleton.dart';
import '../tab_screen.dart';
import './profile_view_model.dart';
import './widgets/profile_button.dart';
import '../../../services/auth.dart';
import '../../auth.screen/signin.auth/signin_view_model.dart';
import '../../auth.screen/signup.auth/signup_view_model.dart';
import '../hometab.screen/hometab_view_model.dart';
import 'edit_profile/edit_profile_view_model.dart';

class ProfileTabScreen extends HookWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: true);
    final useViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final user = User.fromJson(authService.userInfo["user"]);
    final dimension = Utils.getDimensions(context, true);
    final disposableProvider = [
      Provider.of<SignInViewModel>(context, listen: false),
      Provider.of<SignUpViewModel>(context, listen: false),
      Provider.of<HomeTabViewModel>(context, listen: false),
      Provider.of<AuthService>(context, listen: false),
      Provider.of<EditProfileViewModel>(context, listen: false),
      Provider.of<TabViewModel>(context, listen: false),
      Provider.of<JankariViewModel>(context, listen: false),
      Provider.of<MyProfileViewModel>(context, listen: false),
    ];
    final profileImage = user.profileImage!.split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        title: BaseText(
          title: AppLocalizations.of(context)!.settinghi,
          style: const TextStyle(
            color: AppColor.darkBlackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 180,
              child: Column(children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
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
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ParagraphHeadingText(user.name!)
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileButton(
                onPress: () => useViewModel.goToEditProfileScreen(context),
                leftIcon: "assets/icons/profile.png",
                title: AppLocalizations.of(context)!.editprofilehi,
                width: dimension["width"]! - 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileButton(
                onPress: () => Utils.launchDialer('7879810802'),
                leftIcon: "assets/images/calladd.png",
                title: AppLocalizations.of(context)!.contactsupporthi,
                width: dimension["width"]! - 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileButton(
                onPress: () => useViewModel.openTermsAndConditions(context),
                leftIcon: "assets/icons/terms.png",
                title: AppLocalizations.of(context)!.termsandConditionhi,
                width: dimension["width"]! - 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileButton(
                onPress: () => useViewModel.openPrivacyPolicy(context),
                leftIcon: "assets/images/lock.png",
                title: AppLocalizations.of(context)!.privacyPolicyhi,
                width: dimension["width"]! - 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileButton(
                onPress: () {
                  showDeleteAccountDialog(
                      context, useViewModel, disposableProvider);
                },
                leftIcon: "assets/images/trash.png",
                title: AppLocalizations.of(context)!.deleteAccounthi,
                width: dimension["width"]! - 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileButton(
                onPress: () =>
                    useViewModel.handleLogOut(context, disposableProvider),
                leftIcon: "assets/images/logout.png",
                title: AppLocalizations.of(context)!.logouthi,
                width: dimension["width"]! - 32,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
