import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              content: BaseText(
                  title: AppLocalizations.of(context)!.confirmDeletehi,
                  style: const TextStyle()),
              actions: <Widget>[
                TextButton(
                  child: BaseText(
                      title: AppLocalizations.of(context)!.yeshi,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    useViewModel.handleDelete(context, disposableProvider);
                    Navigator.of(dialogContext).pop();
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
