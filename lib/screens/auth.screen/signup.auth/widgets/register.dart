import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/Input.widgets/input.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';
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
      useViewModel.fetchStates(context);
      return () => useViewModel.disposeRegisterUserformKey();
    }, []);

    Future<bool> onWillPop() async {
      Navigator.of(context).pushNamedAndRemoveUntil(RouteName.authLandingRoute, (route) => false);
      return false;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
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
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteName.authLandingRoute, (route) => false);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: [
                            SubHeadingText(AppLocalization.of(context)
                                .getTranslatedValue("signupTitle")
                                .toString())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("signupSubtitle")
                              .toString(),
                          style: const TextStyle(
                              color: AppColor.midBlackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: Column(
                    children: [
                      Form(
                        key: useViewModel.registerUserformKey,
                        child: Column(
                          children: [
                            Consumer<SignUpViewModel>(
                              builder: (context, provider, child) => Input(
                                labelText: AppLocalization.of(context)
                                    .getTranslatedValue("signupFormName")
                                    .toString(),
                                focusNode: useViewModel.nameFocusNode,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                suffixIcon: useViewModel.suffixIconForName(),
                                initialValue: provider.userName,
                                validator: (value) =>
                                    useViewModel.nameFieldValidator(context, value),
                                onSaved: useViewModel.onSavedNameField,
                                onFieldSubmitted: (_) {
                                  Utils.fieldFocusChange(context, useViewModel.nameFocusNode,
                                      useViewModel.emailFocusNode);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Input(
                              labelText: AppLocalization.of(context)
                                  .getTranslatedValue("signupFormEmail")
                                  .toString(),
                              focusNode: useViewModel.emailFocusNode,
                              suffixIcon: useViewModel.suffixIconForEmail(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              validator: (value) =>
                                  useViewModel.emailFieldValidator(context, value),
                              onSaved: useViewModel.onSavedEmailField,
                              onFieldSubmitted: (_) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<SignUpViewModel>(builder: (context, provider, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                width: dimension['width']! * 0.90,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.extraDark, width: 2.0),
                                  color: Colors.white,
                                ),
                                child: DropdownButton(
                                    underline: Container(),
                                    isExpanded: true,
                                    hint: BaseText(
                                      title: AppLocalization.of(context)
                                          .getTranslatedValue("signupFormSelectState")
                                          .toString(),
                                      style: const TextStyle(),
                                    ),
                                    value: provider.selectedState.isEmpty
                                        ? null
                                        : provider.selectedState,
                                    alignment: AlignmentDirectional.centerStart,
                                    items: provider.stateList
                                        .map<DropdownMenuItem<String>>((dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value.state,
                                        child: BaseText(
                                          title:
                                              AppLocalization.of(context).locale.toString() == "en"
                                                  ? value.state
                                                  : value.stateHi,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      provider.setSelectedState(context, value!);
                                    }),
                              );
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            useViewModel.districtList.isEmpty
                                ? InkWell(
                                    onTap: () => Utils.snackbar(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("validateState")
                                            .toString(),
                                        context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      width: dimension['width']! * 0.90,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColor.extraDark, width: 2.0),
                                        color: Colors.white,
                                      ),
                                      child: DropdownButton(
                                          underline: Container(),
                                          isExpanded: true,
                                          hint: BaseText(
                                            title: AppLocalization.of(context)
                                                .getTranslatedValue("signupFormSelectDistrict")
                                                .toString(),
                                            style: const TextStyle(),
                                          ),
                                          value: null,
                                          alignment: AlignmentDirectional.centerStart,
                                          items: const [],
                                          onChanged: (_) {}),
                                    ),
                                  )
                                : Consumer<SignUpViewModel>(builder: (context, provider, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      width: dimension['width']! * 0.90,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColor.extraDark, width: 2.0),
                                        color: Colors.white,
                                      ),
                                      child: DropdownButton(
                                          underline: Container(),
                                          isExpanded: true,
                                          hint: BaseText(
                                            title: AppLocalization.of(context)
                                                .getTranslatedValue("signupFormSelectDistrict")
                                                .toString(),
                                            style: const TextStyle(),
                                          ),
                                          value: provider.selectedDistrictHi.isEmpty
                                              ? null
                                              : provider.selectedDistrictHi,
                                          alignment: AlignmentDirectional.centerStart,
                                          items: provider.districtList
                                              .map<DropdownMenuItem<String>>((value) {
                                            return DropdownMenuItem<String>(
                                              onTap: () {
                                                provider.setSelectedDistrictEn(value);
                                              },
                                              value:
                                                  AppLocalization.of(context).locale.toString() ==
                                                          "en"
                                                      ? value.name
                                                      : value.nameHi,
                                              child: BaseText(
                                                title:
                                                    AppLocalization.of(context).locale.toString() ==
                                                            "en"
                                                        ? value.name
                                                        : value.nameHi,
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            provider.setSelectedDistrict(value!);
                                          }),
                                    );
                                  }),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<SignUpViewModel>(
                              builder: (context, provider, child) => Input(
                                labelText: AppLocalization.of(context)
                                    .getTranslatedValue("signupFormVillage")
                                    .toString(),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.done,
                                suffixIcon: useViewModel.suffixIconForVillage(),
                                validator: (value) =>
                                    useViewModel.villageFieldValidator(context, value),
                                onSaved: useViewModel.onSavedvillageField,
                                onChanged: (value) => useViewModel.onSavedvillageField(value),
                                onFieldSubmitted: (value) {
                                  useViewModel.setVillage(value);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Consumer<SignUpViewModel>(
                              builder: (context, provider, child) => CustomElevatedButton(
                                title: AppLocalization.of(context)
                                    .getTranslatedValue("register")
                                    .toString(),
                                width: dimension["width"]! - 32,
                                loading: provider.loading,
                                onPress: () => provider.saveRegisterUserForm(context),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
