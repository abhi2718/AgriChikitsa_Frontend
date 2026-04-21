import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';

class DeleteFieldWarningScreen extends StatelessWidget {
  const DeleteFieldWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AGPlusViewModel>(context, listen: false);

    final List<Map<String, dynamic>> warningPoints = [
      {
        "icon": Icons.agriculture,
        "text": AppLocalization.of(context)
            .getTranslatedValue("deleteWarningCropMonitoring")
            .toString(),
      },
      {
        "icon": Icons.storage,
        "text":
            AppLocalization.of(context).getTranslatedValue("deleteWarningCropDataLost").toString(),
      },
      {
        "icon": Icons.medical_services,
        "text": AppLocalization.of(context).getTranslatedValue("deleteWarningAdvisory").toString(),
      },
      {
        "icon": Icons.cloud,
        "text": AppLocalization.of(context).getTranslatedValue("deleteWarningWeather").toString(),
      },
      {
        "icon": Icons.grass,
        "text": AppLocalization.of(context)
            .getTranslatedValue("deleteWarningWeedProtection")
            .toString(),
      },
      {
        "icon": Icons.store,
        "text": AppLocalization.of(context).getTranslatedValue("deleteWarningMandi").toString(),
      },
      {
        "icon": Icons.description,
        "text":
            AppLocalization.of(context).getTranslatedValue("deleteWarningSoilReport").toString(),
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).getTranslatedValue("deleteField").toString(),
        ),
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
      ),
      body: Consumer<AGPlusViewModel>(builder: (_, vm, __) {
        if (vm.isFieldDeleting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.extraDark,
          ));
        }
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    /// Warning header
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 60,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("deleteFieldWarningTitle")
                          .toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    /// Warning points
                    ...warningPoints.map(
                      (point) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              point["icon"],
                              color: AppColor.errorColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                point["text"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Bottom fixed delete button
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    showFinalWarningDialog(context, vm);
                  },
                  child: Text(
                    AppLocalization.of(context).getTranslatedValue("deleteTitle").toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

void showFinalWarningDialog(BuildContext context, AGPlusViewModel useViewModel) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: BaseText(
          title: AppLocalization.of(context).getTranslatedValue("warningTitle").toString(),
          style: TextStyle(color: AppColor.errorColor),
        ),
        content: BaseText(
          title: AppLocalization.of(context).getTranslatedValue("confirmDeleteField").toString(),
          style: TextStyle(),
        ),
        actions: [
          TextButton(
            child: BaseText(
              title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.errorColor,
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              useViewModel.deleteField(context);
            },
          ),
          TextButton(
            child: BaseText(
              title: AppLocalization.of(context).getTranslatedValue("no").toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.extraDark,
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}
