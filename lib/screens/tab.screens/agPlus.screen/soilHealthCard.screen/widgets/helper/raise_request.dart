import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void showRaiseRequest(BuildContext context, dynamic dimension) {
  showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Consumer<AGPlusViewModel>(
            builder: (context, provider, child) {
              if (provider.requestStatus) {
                String? translated = AppLocalization.of(context).getTranslatedValue(
                  provider.isAlreadyRequested ? "alreadyRequested" : "successfullySubmit",
                );
                String displayMsg = (translated != null && translated.isNotEmpty && translated != 'null')
                    ? translated
                    : (provider.isAlreadyRequested
                        ? "आपका अनुरोध पहले ही किया जा चुका है"
                        : "अनुरोध सफलतापूर्वक सबमिट किया गया");

                return Container(
                  height: dimension["height"]! * 0.38,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Icon(
                          provider.isAlreadyRequested
                              ? Icons.error_rounded
                              : Icons.check_circle_rounded,
                          color: provider.isAlreadyRequested
                              ? AppColor.errorColor
                              : AppColor.extraDark,
                          size: dimension['height']! * 0.085,
                        ),
                      ),
                      Text(
                        displayMsg,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColor.darkBlackColor,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isAlreadyRequested
                              ? AppColor.errorColor
                              : AppColor.extraDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                        ),
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          "OK",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                      padding: const EdgeInsets.all(16.0),
                      height: dimension["height"]! * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RequestDetails(
                            dimension: dimension,
                            title: provider.phoneNumber,
                          ),
                          RequestDetails(
                            dimension: dimension,
                            title: provider.selectedPlot.fieldName,
                          ),
                          RequestDetails(
                            dimension: dimension,
                            title: provider.selectedPlot.area,
                          ),
                          CustomElevatedButton(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("submitButton")
                                .toString(),
                            onPress: () {
                              provider.raiseRequest(context, provider.selectedPlot.id);
                            },
                            loading: provider.requestLoader,
                          ),
                        ],
                      ),
                    );
            },
          ),
        );
      });
}

class RequestDetails extends StatelessWidget {
  const RequestDetails({super.key, required this.dimension, required this.title});
  final dynamic dimension;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 8),
      height: dimension["height"]! * (0.4 * 0.2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(9)),
      child: Center(
        child: Text(title),
      ),
    );
  }
}
