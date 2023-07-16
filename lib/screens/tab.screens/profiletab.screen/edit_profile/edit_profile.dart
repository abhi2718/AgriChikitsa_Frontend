import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return 
       Scaffold(
        backgroundColor: AppColor.notificationBgColor,
         appBar: AppBar(
        title: BaseText(
          title: AppLocalizations.of(context)!.notificationhi,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Remix.arrow_left_line,
              color: AppColor.darkBlackColor,
            )),
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
                ),
              ),
              const SizedBox(
                height: 16,
              ),
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
                          labelText: AppLocalizations.of(context)!.namehi,
                          focusNode: useViewModel.nameFocusNode,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          suffixIcon: useViewModel.suffixIconForName(),
                          initialValue: user.name!,
                          validator: (value) =>
                              useViewModel.nameFieldValidator(context, value),
                          onChanged: (value) {
                            useViewModel.onSavedNameField(value);
                          },
                          onEditingComplete: () {
                            useViewModel.onSavedNameField;
                          },
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onSaved: useViewModel.onSavedNameField,
                          onFieldSubmitted: (value) {
                            useViewModel.onSavedNameField(value);
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
                          labelText: AppLocalizations.of(context)!.emailhi,
                          focusNode: useViewModel.emailFocusNode,
                          suffixIcon: useViewModel.suffixIconForEmail(),
                          keyboardType: TextInputType.emailAddress,
                          initialValue: user.email ?? "",
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              useViewModel.emailFieldValidator(context, value),
                          onSaved: useViewModel.onSavedEmailField,
                          onFieldSubmitted: (_) {},
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Consumer<EditProfileViewModel>(
                        builder: (context, provider, child) =>
                            CustomElevatedButton(
                                title: AppLocalizations.of(context)!.updatehi,
                                loading: provider.loading,
                                width: dimension["width"]! - 32,
                                onPress: () {
                                  provider.saveForm(context, user, authService);
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
