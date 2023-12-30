// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// import '../../../../../res/color.dart';
// import '../../../../../utils/utils.dart';
// import '../../../../../widgets/text.widgets/text.dart';
// import '../../agPlus_view_model.dart';

// class FieldStatusScreen extends HookWidget {
//   const FieldStatusScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final dimension = Utils.getDimensions(context, true);
//     final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
//     useEffect(() {
//       Timer(Duration(milliseconds: 2500), () {
//         Navigator.popUntil(context, (route) => route.isFirst);
//       });
//     }, []);
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColor.notificationBgColor,
//         body: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset(
//                   useViewModel.fieldStatus
//                       ? 'assets/lottie/success.json'
//                       : 'assets/lottie/fail.json',
//                   height: dimension['height']! * 0.30,
//                   width: dimension['width']! * 0.50,
//                 ),
//                 BaseText(
//                   title: useViewModel.fieldStatus!
//                       ? AppLocalizations.of(context)!.successFieldMessagehi
//                       : AppLocalizations.of(context)!.errorMessagehi,
//                   style: const TextStyle(fontSize: 18, color: Colors.black54),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';

void addPlotStatus(
  BuildContext context,
) {
  final dimension = Utils.getDimensions(context, true);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Consumer<AGPlusViewModel>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: dimension["height"]! * 0.3,
                child: provider.addFieldLoader
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.extraDark,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          provider.fieldStatus
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/plot_success.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Lottie.asset(
                                  'assets/lottie/fail.json',
                                  height: dimension['height']! * 0.10,
                                  width: dimension['width']! * 0.30,
                                ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            provider.fieldStatus
                                ? AppLocalization.of(context)
                                    .getTranslatedValue("plotAddedSuccessfully")
                                    .toString()
                                : "${AppLocalization.of(context).getTranslatedValue("oopsTitle").toString()} ${AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              );
            },
          ),
        );
      });
}
