import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/Input.widgets/input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../../../../widgets/tools.widgets/tools.dart';
import '../signup_view_model.dart';

class RegisterUser extends HookWidget {
  final String phoneNumber;
  final String uid;
  const RegisterUser({super.key, required this.phoneNumber, required this.uid});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<SignUpViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.disposeValues();
      useViewModel.setPhoneNumber(phoneNumber);
      useViewModel.setFirebaseId(uid);
      return () => useViewModel.disposeRegisterUserformKey();
    }, []);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: AppColor.lightColor,
                width: double.infinity,
                alignment: Alignment.topLeft,
                height: 120,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Row(
                        children: [
                          SubHeadingText(
                              AppLocalizations.of(context)!.createAccounthi)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            ParagraphText(
                              AppLocalizations.of(context)!.joinAgrichikitsahi,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Column(
                  children: [
                    Form(
                      key: useViewModel.registerUserformKey,
                      child: Column(
                        children: [
                          Consumer<SignUpViewModel>(
                            builder: (context, provider, child) => Input(
                              labelText: AppLocalizations.of(context)!.namehi,
                              focusNode: useViewModel.nameFocusNode,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              suffixIcon: useViewModel.suffixIconForName(),
                              initialValue: provider.userName,
                              validator: (value) => useViewModel
                                  .nameFieldValidator(context, value),
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
                            height: 20,
                          ),
                          Input(
                            labelText: AppLocalizations.of(context)!.emailhi,
                            focusNode: useViewModel.emailFocusNode,
                            suffixIcon: useViewModel.suffixIconForEmail(),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: (value) => useViewModel
                                .emailFieldValidator(context, value),
                            onSaved: useViewModel.onSavedEmailField,
                            onFieldSubmitted: (_) {},
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Consumer<SignUpViewModel>(
                            builder: (context, provider, child) =>
                                CustomElevatedButton(
                              title: "Register",
                              width: dimension["width"]! - 32,
                              loading: provider.loading,
                              onPress: () =>
                                  provider.saveRegisterUserForm(context),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
