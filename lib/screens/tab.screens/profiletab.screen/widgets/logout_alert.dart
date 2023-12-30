import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../../res/color.dart';

void showLogoutAccountDialog(
    BuildContext context, ProfileViewModel useViewModel, List<dynamic> disposableProvider) {
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
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                ),
              ),
            )
          : AlertDialog(
              title: BaseText(
                  title: AppLocalization.of(context).getTranslatedValue("logoutTitle").toString(),
                  style: const TextStyle()),
              content: BaseText(
                  title: AppLocalization.of(context).getTranslatedValue("confirmLogout").toString(),
                  style: const TextStyle()),
              actions: <Widget>[
                TextButton(
                  child: BaseText(
                      title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
                      style: const TextStyle(fontSize: 16, color: AppColor.extraDark)),
                  onPressed: () {
                    useViewModel.handleLogOut(context, disposableProvider);
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
