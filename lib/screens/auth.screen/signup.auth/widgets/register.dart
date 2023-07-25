import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/Input.widgets/input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      useViewModel.getStates(context);
      return () => useViewModel.disposeRegisterUserformKey();
    }, []);

    Future<bool> onWillPop() async {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.authLandingRoute, (route) => false);
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
                                AppLocalizations.of(context)!
                                    .joinAgrichikitsahi,
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
                              height: 20,
                            ),
                            Consumer<SignUpViewModel>(
                                builder: (context, provider, child) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: dimension['width']! * 0.90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.extraDark, width: 2.0),
                                  color: Colors.white,
                                ),
                                child: DropdownButton(
                                    underline: Container(),
                                    isExpanded: true,
                                    hint: BaseText(
                                      title: AppLocalizations.of(context)!
                                          .selectState,
                                      style: const TextStyle(),
                                    ),
                                    value: provider.selectedState.isEmpty
                                        ? null
                                        : provider.selectedState,
                                    alignment: AlignmentDirectional.centerStart,
                                    items: provider.stateList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: BaseText(
                                          title: value,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      provider.setSelectedState(value!);
                                    }),
                              );
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            useViewModel.districtList.isEmpty
                                ? InkWell(
                                    onTap: () => Utils.snackbar(
                                        AppLocalizations.of(context)!
                                            .warningSelectState,
                                        context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: dimension['width']! * 0.90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.extraDark,
                                            width: 2.0),
                                        color: Colors.white,
                                      ),
                                      child: DropdownButton(
                                          underline: Container(),
                                          isExpanded: true,
                                          hint: BaseText(
                                            title: AppLocalizations.of(context)!
                                                .selectDistrict,
                                            style: const TextStyle(),
                                          ),
                                          value: null,
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          items: [],
                                          onChanged: (_) {}),
                                    ),
                                  )
                                : Consumer<SignUpViewModel>(
                                    builder: (context, provider, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: dimension['width']! * 0.90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.extraDark,
                                            width: 2.0),
                                        color: Colors.white,
                                      ),
                                      child: DropdownButton(
                                          underline: Container(),
                                          isExpanded: true,
                                          hint: BaseText(
                                            title: AppLocalizations.of(context)!
                                                .selectDistrict,
                                            style: const TextStyle(),
                                          ),
                                          value: provider
                                                  .selectedDistrictHi.isEmpty
                                              ? null
                                              : provider.selectedDistrictHi,
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          items: provider.districtList
                                              .map<DropdownMenuItem<String>>(
                                                  (value) {
                                            return DropdownMenuItem<String>(
                                              onTap: () {
                                                provider.setSelectedDistrictEn(
                                                    value);
                                              },
                                              value: value['nameHi'],
                                              child: BaseText(
                                                title: value['nameHi'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            // print(value);
                                            provider
                                                .setSelectedDistrict(value!);
                                          }),
                                    );
                                  }),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<SignUpViewModel>(
                              builder: (context, provider, child) => Input(
                                labelText:
                                    AppLocalizations.of(context)!.villagehi,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.done,
                                suffixIcon: useViewModel.suffixIconForVillage(),
                                validator: (value) => useViewModel
                                    .villageFieldValidator(context, value),
                                onSaved: useViewModel.onSavedvillageField,
                                onFieldSubmitted: (_) {},
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Consumer<SignUpViewModel>(
                              builder: (context, provider, child) =>
                                  CustomElevatedButton(
                                title: AppLocalizations.of(context)!.registerhi,
                                width: dimension["width"]! - 32,
                                loading: provider.loading,
                                onPress: () =>
                                    provider.saveRegisterUserForm(context),
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
