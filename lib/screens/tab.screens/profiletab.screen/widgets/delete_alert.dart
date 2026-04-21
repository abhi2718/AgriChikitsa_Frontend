import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/Input.widgets/input.dart';

void showDeleteAccountDialog(
    BuildContext context, ProfileViewModel useViewModel, List<dynamic> disposableProvider) {
  final dimension = Utils.getDimensions(context, true);
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return useViewModel.deleteLoader
          ? AlertDialog(
              content: SizedBox(
                width: dimension['width'],
                height: dimension['height']! * 0.23,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                ),
              ),
            )
          : AlertDialog(
              title: BaseText(
                  title: AppLocalization.of(context)
                      .getTranslatedValue("accountDeleteTitle")
                      .toString(),
                  style: const TextStyle()),
              content: SizedBox(
                width: dimension['width'],
                height: dimension['height']! * 0.23,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      title: AppLocalization.of(context)
                          .getTranslatedValue("confirmDelete")
                          .toString(),
                      style: const TextStyle(),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Input(
                      labelText:
                          AppLocalization.of(context).getTranslatedValue("validReason").toString(),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      validator: (value) => useViewModel.nameFieldValidator(context, value),
                      onChanged: (value) {
                        useViewModel.onSavedReasonField(value);
                      },
                      onEditingComplete: () {
                        useViewModel.onSavedReasonField;
                      },
                      onSaved: useViewModel.onSavedReasonField,
                      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                      onFieldSubmitted: (value) {
                        useViewModel.onSavedReasonField(value);
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: BaseText(
                      title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
                      style: const TextStyle(fontSize: 16, color: AppColor.extraDark)),
                  onPressed: () {
                    if (useViewModel.deleteReason.isNotEmpty &&
                        useViewModel.deleteReason.length > 3) {
                      useViewModel.handleDelete(context, disposableProvider);
                    } else {
                      Utils.flushBarErrorMessage(
                          AppLocalization.of(context).getTranslatedValue("alert").toString(),
                          AppLocalization.of(context).getTranslatedValue("validReason").toString(),
                          context);
                    }
                  },
                ),
                TextButton(
                  child: BaseText(
                      title: AppLocalization.of(context).getTranslatedValue("no").toString(),
                      style: const TextStyle(fontSize: 16, color: AppColor.extraDark)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
    },
  );
}
