import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showRaiseRequest(BuildContext context, dynamic dimension) {
  showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Consumer<AGPlusViewModel>(
            builder: (context, provider, child) {
              return provider.requestStatus
                  ? Container(
                      height: dimension["height"]! * 0.4,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColor.extraDark,
                              size: dimension['height']! * 0.1,
                            ),
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("successfullySubmit")
                                .toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  : Container(
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
                              provider.raiseRequest(context, provider.selectedPlot.fieldName,
                                  provider.selectedPlot.id);
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
