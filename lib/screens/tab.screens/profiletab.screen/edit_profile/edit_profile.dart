import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import './edit_profile_view_model.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/Input.widgets/input.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/tools.widgets/upload_profile.dart';

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<EditProfileViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: true);
    final user = User.fromJson(authService.userInfo["user"]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Remix.arrow_left_line,
            ),
          ),
          title: BaseText(
            title: AppLocalizationsHi().editProfile,
            style: const TextStyle(
              color: AppColor.darkBlackColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: dimension["width"]! - 32,
                  // child: Row(
                  //   children: [
                  //     BackIconButton(onTap: () => useViewModel.goBack(context)),
                  //   ],
                  // ),
                ),
              ),
              // const SizedBox(
              //   height: 16,
              // ),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [SubHeadingText("Edit Profile")],
              // ),
              const SizedBox(
                height: 16,
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(40),
              //   child: Image.network(
              //     "https://cdn.imgbin.com/6/25/24/imgbin-user-profile-computer-icons-user-interface-mystique-aBhn3R8cmqmP4ECky4DA3V88y.jpg",
              //     width: 80,
              //     height: 80,
              //   ),
              // ),
              ProfilePicture(
                picImage: useViewModel.pickProfileImage,
                captureImage: useViewModel.captureProfileImage,
                authService: authService,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: useViewModel.editUserformKey,
                  child: Column(
                    children: [
                      Consumer<EditProfileViewModel>(
                        builder: (context, provider, child) => Input(
                          labelText: "Name",
                          focusNode: useViewModel.nameFocusNode,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          suffixIcon: useViewModel.suffixIconForName(),
                          initialValue: user.name!,
                          validator: useViewModel.nameFieldValidator,
                          onSaved: useViewModel.onSavedNameField,
                          onFieldSubmitted: (_) {
                            Utils.fieldFocusChange(
                                context,
                                useViewModel.nameFocusNode,
                                useViewModel.emailFocusNode);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Consumer<EditProfileViewModel>(
                        builder: (context, provider, child) => Input(
                          labelText: "Email",
                          focusNode: useViewModel.emailFocusNode,
                          suffixIcon: useViewModel.suffixIconForEmail(),
                          keyboardType: TextInputType.emailAddress,
                          initialValue: user.email ?? "",
                          textInputAction: TextInputAction.done,
                          validator: useViewModel.emailFieldValidator,
                          onSaved: useViewModel.onSavedEmailField,
                          onFieldSubmitted: (_) =>
                              provider.saveForm(context, user, authService),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Consumer<EditProfileViewModel>(
                        builder: (context, provider, child) =>
                            CustomElevatedButton(
                          title: "Update",
                          loading: provider.loading,
                          width: dimension["width"]! - 32,
                          onPress: () =>
                              provider.saveForm(context, user, authService),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
