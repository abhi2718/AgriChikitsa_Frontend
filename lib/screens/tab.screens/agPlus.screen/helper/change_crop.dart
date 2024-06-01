import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/select_crop.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ag_plus_view_model.dart';

class ChangeCrop extends StatelessWidget {
  const ChangeCrop({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    return Container(
      height: dimension['height']! * 0.2,
      padding: const EdgeInsets.all(8),
      width: dimension['width'],
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Icon(Icons.horizontal_rule)),
          ListTile(
            onTap: () {
              useViewModel.fetchCropCategories(context);
              Utils.model(
                  context,
                  CropSelection(
                    isFromFieldScreen: true,
                    fieldId: useViewModel.selectedPlot.id,
                  ));
              // showDialog(
              //   context: context,
              //   builder: (BuildContext dialogContext) {
              //     return Dialog(
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //       child: IntrinsicHeight(
              //         child: Padding(
              //           padding: const EdgeInsets.all(16.0),
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 AppLocalization.of(context)
              //                     .getTranslatedValue("youtubeLink")
              //                     .toString(),
              //                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              //               ),
              //               const SizedBox(height: 16),
              //               TextField(
              //                 decoration: InputDecoration(
              //                   hintText: AppLocalization.of(context)
              //                       .getTranslatedValue("enterHere")
              //                       .toString(),
              //                   enabledBorder: OutlineInputBorder(
              //                     borderSide: const BorderSide(color: Colors.grey),
              //                     borderRadius: BorderRadius.circular(8.0),
              //                   ),
              //                   focusedBorder: OutlineInputBorder(
              //                     borderSide: const BorderSide(color: Colors.green),
              //                     borderRadius: BorderRadius.circular(8.0),
              //                   ),
              //                 ),
              //               ),
              //               TextButton(
              //                 onPressed: () {},
              //                 child: Text(
              //                   AppLocalization.of(context)
              //                       .getTranslatedValue("submitButton")
              //                       .toString(),
              //                   style: const TextStyle(color: Colors.green),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // );
            },
            title: Text(
              AppLocalization.of(context).getTranslatedValue("changeCrop").toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
