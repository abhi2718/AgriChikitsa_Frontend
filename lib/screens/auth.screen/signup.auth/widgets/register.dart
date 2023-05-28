import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/Input.widgets/input.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../../../../widgets/tools.widgets/tools.dart';
import '../signup_view_model.dart';

class RegisterUser extends HookWidget {
  const RegisterUser({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<SignUpViewModel>(context, listen: false);
    useEffect(() {
      return () => useViewModel.disposeRegisterUserformKey();
    }, []);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: dimension["width"]! - 32,
                child: Row(
                  children: [
                    BackIconButton(onTap: () => useViewModel.goBack(context)),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SmallLogo(),
              const SizedBox(
                height: 20,
              ),
              const SubHeadingText(
                "Register",
                fontSize: 26,
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
                              labelText: "Name",
                              focusNode: useViewModel.nameFocusNode,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              suffixIcon: useViewModel.suffixIconForName(),
                              initialValue: provider.userName,
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
                          Input(
                            labelText: "Email",
                            focusNode: useViewModel.emailFocusNode,
                            suffixIcon: useViewModel.suffixIconForEmail(),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: useViewModel.emailFieldValidator,
                            onSaved: useViewModel.onSavedEmailField,
                            onFieldSubmitted: (_) {
                              Utils.fieldFocusChange(
                                  context,
                                  useViewModel.emailFocusNode,
                                  useViewModel.passwordFocusNode);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Consumer<SignUpViewModel>(
                              builder: (context, provider, child) {
                            return Input(
                              labelText: "Password",
                              focusNode: useViewModel.passwordFocusNode,
                              suffixIcon: useViewModel.suffixIconForPassword(),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              validator: useViewModel.passwordFieldValidator,
                              obscureText: provider.showPassword,
                              onSaved: useViewModel.onSavedPasswordlField,
                              onFieldSubmitted: (_) {
                                Utils.fieldFocusChange(
                                    context,
                                    useViewModel.passwordFocusNode,
                                    useViewModel.confirmPasswordFocusNode);
                              },
                            );
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Consumer<SignUpViewModel>(
                              builder: (context, provider, child) {
                            return Input(
                              labelText: "Confirm Password",
                              obscureText: provider.showConfirmPassword,
                              focusNode: useViewModel.confirmPasswordFocusNode,
                              suffixIcon:
                                  provider.suffixIconForConfirmPassword(),
                              validator:
                                  useViewModel.confirmPasswordFieldValidator,
                              onSaved:
                                  useViewModel.onSavedConfirmPasswordlField,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                Utils.fieldFocusChange(
                                    context,
                                    useViewModel.confirmPasswordFocusNode,
                                    useViewModel.mobileNumberFocusNode);
                              },
                            );
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Input(
                            labelText: "Mobile Number",
                            focusNode: useViewModel.mobileNumberFocusNode,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            suffixIcon:
                                useViewModel.suffixIconForMobileNumber(),
                            validator: useViewModel.mobileNumerFieldValidator,
                            onSaved: useViewModel.onSavedMobileNumerField,
                            onFieldSubmitted: (_) =>
                                useViewModel.saveRegisterUserForm(context),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Consumer<SignUpViewModel>(
                            builder: (context, provider, child) =>
                                CustomElevatedButton(
                              title: "Register",
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
