import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../widgets/Input.widgets/input.dart';

void showDeleteAccountDialog(BuildContext context,
    ProfileViewModel useViewModel, List<dynamic> disposableProvider) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return useViewModel.deleteLoader
          ? const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : AlertDialog(
              title: BaseText(
                  title: AppLocalizations.of(context)!.deleteAccounthi,
                  style: const TextStyle()),
              content: SizedBox(
                height: 125,
                child: Column(
                  children: [
                    BaseText(
                        title: AppLocalizations.of(context)!.confirmDeletehi,
                        style: const TextStyle()),
                    const SizedBox(
                      height: 20,
                    ),
                    Input(
                      labelText: AppLocalizations.of(context)!.validReasonhi,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          useViewModel.nameFieldValidator(context, value),
                      onChanged: (value) {
                        useViewModel.onSavedReasonField(value);
                      },
                      onEditingComplete: () {
                        useViewModel.onSavedReasonField;
                      },
                      onSaved: useViewModel.onSavedReasonField,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
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
                      title: AppLocalizations.of(context)!.yeshi,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    if (useViewModel.deleteReason.isNotEmpty &&
                        useViewModel.deleteReason.length > 3) {
                      useViewModel.handleDelete(context, disposableProvider);
                      Navigator.of(dialogContext).pop();
                    } else {
                      Utils.flushBarErrorMessage(
                          AppLocalizations.of(context)!.alerthi,
                          AppLocalizations.of(context)!.validReasonhi,
                          context);
                    }
                  },
                ),
                TextButton(
                  child: BaseText(
                      title: AppLocalizations.of(context)!.nohi,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
    },
  );
}
