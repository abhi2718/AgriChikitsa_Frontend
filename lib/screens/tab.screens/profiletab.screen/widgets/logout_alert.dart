import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showLogoutAccountDialog(BuildContext context,
    ProfileViewModel useViewModel, List<dynamic> disposableProvider) {
  final dimension = Utils.getDimensions(context, true);
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return useViewModel.deleteLoader
          ? AlertDialog(
              content: SizedBox(
                width: dimension['width'],
                height: dimension['height']! * 0.18,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : AlertDialog(
              title: BaseText(
                  title: AppLocalizations.of(context)!.accountLogouthi,
                  style: const TextStyle()),
              content: BaseText(
                  title: AppLocalizations.of(context)!.accountLogoutConfirmhi,
                  style: const TextStyle()),
              actions: <Widget>[
                TextButton(
                  child: BaseText(
                      title: AppLocalizations.of(context)!.yeshi,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    useViewModel.handleLogOut(context, disposableProvider);
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
