import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../tab_screen.dart';
import './profile_view_model.dart';
import './widgets/profile_button.dart';
import '../../../services/auth.dart';
import '../../../services/socket_io.dart';
import '../../auth.screen/signin.auth/signin_view_model.dart';
import '../../auth.screen/signup.auth/signup_view_model.dart';
import '../chattab.screen/chat_tab_view_model.dart';
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
      Provider.of<SocketService>(context, listen: false),
      Provider.of<HomeTabViewModel>(context, listen: false),
      Provider.of<AuthService>(context, listen: false),
      Provider.of<ChatTabViewModel>(context, listen: false),
      Provider.of<EditProfileViewModel>(context, listen: false),
      Provider.of<TabViewModel>(context, listen: false)
    ];
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
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
                Container(
                  alignment: Alignment.bottomRight,
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: user.profileImage != null
                          ? NetworkImage(user.profileImage!)
                          : const NetworkImage(
                              defaultImage,
                            ),
                    ),
                  ),
                  child: Container(),
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
                leftIcon: "assets/images/Profile.png",
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
                onPress: () => Utils.launchDialer('8318064327'),
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
                leftIcon: "assets/images/Terms And Condition.png",
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
                  // useViewModel.handleDelete(
                  //     context, user.companyId!, disposableProvider);
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
            // CustomElevatedButton(
            //   onPress: () => useViewModel.handleLocaleChange(),
            //   title: "Change Local",
            //   width: dimension["width"]! - 32,
            // ),
          ],
        ),
      ),
    );
  }
}
