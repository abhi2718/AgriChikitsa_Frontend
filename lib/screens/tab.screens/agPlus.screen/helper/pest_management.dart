import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agristick.screen/agristick_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agristick.screen/agristick_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../model/plots.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';

class PestManagement extends StatelessWidget {
  const PestManagement(
      {super.key,
      required this.selectedPlots,
      required this.agPlusViewModel,
      required this.isIrrigationCardTapped});
  final Plots selectedPlots;
  final AGPlusViewModel agPlusViewModel;
  final bool isIrrigationCardTapped;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          isIrrigationCardTapped
              ? AppLocalization.of(context).getTranslatedValue("irrigationTitle").toString()
              : AppLocalization.of(context).getTranslatedValue("pestManagementTitle").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Player(
                  videoUrl: "https://youtu.be/DD8As1BPh1w?si=HHEu8RAguDcJrNuN",
                  aspectRatio: 16 / 9),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: dimension['width']!,
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Text(
                isIrrigationCardTapped
                    ? AppLocalization.of(context)
                        .getTranslatedValue("irrigationDescription")
                        .toString()
                    : AppLocalization.of(context).getTranslatedValue("pestDescription").toString(),
                style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: dimension['width']!,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 2), color: Colors.black45, blurRadius: 1, spreadRadius: 0)
                  ]),
              child: Row(
                children: [
                  Image.asset("assets/images/farming.png"),
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("agristickPromoText")
                          .toString(),
                      style: GoogleFonts.hind(fontWeight: FontWeight.w500, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<AgristickViewModel>(builder: (context, provider, child) {
              return InkWell(
                onTap: () => Utils.model(
                    context,
                    AgriStickScreen(
                        currentSelectedPlot: selectedPlots, agPlusViewModel: agPlusViewModel)),
                child: selectedPlots.agristick == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue("addDevice")
                                  .toString(),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87),
                            )
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        height: 60,
                        decoration: BoxDecoration(
                            color: AppColor.darkColor, borderRadius: BorderRadius.circular(12)),
                        width: 140,
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("yourAgristick")
                              .toString(),
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white),
                        )),
              );
            })
          ],
        ),
      ),
    );
  }
}
