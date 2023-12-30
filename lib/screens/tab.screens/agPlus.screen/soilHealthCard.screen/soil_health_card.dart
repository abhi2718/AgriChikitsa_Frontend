import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/soilHealthCard.screen/widgets/helper/raise_request.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/soilHealthCard.screen/widgets/soil_testing_reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';

class SoilHealthCard extends HookWidget {
  const SoilHealthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.getUserDetails();
      useViewModel.requestStatus = false;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.lightColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("soilTestingTitle").toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    AppLocalization.of(context)
                        .getTranslatedValue("soilTestingSubtitle")
                        .toString(),
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      showRaiseRequest(context, dimension);
                    },
                    child: Container(
                      height: dimension["height"]! * 0.08,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(offset: Offset(2, 3), color: Colors.grey)],
                          color: const Color(0xffBEDEB3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        AppLocalization.of(context).getTranslatedValue("raiseRequest").toString(),
                        style: const TextStyle(color: AppColor.darkBlackColor, fontSize: 16),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () => Utils.model(context, const SoilTestingReportScreen()),
                    child: Container(
                      height: dimension["height"]! * 0.08,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(offset: Offset(2, 3), color: Colors.grey)],
                          color: const Color(0xffBEDEB3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        AppLocalization.of(context).getTranslatedValue("reportButton").toString(),
                        style: const TextStyle(color: AppColor.darkBlackColor, fontSize: 16),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () => Utils.model(context, const SoilTestingReportScreen()),
                    child: Container(
                      height: dimension["height"]! * 0.08,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(offset: Offset(2, 3), color: Colors.grey)],
                          color: const Color(0xffBEDEB3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        AppLocalization.of(context).getTranslatedValue("shareReport").toString(),
                        style: const TextStyle(color: AppColor.darkBlackColor, fontSize: 16),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(image: AssetImage("assets/images/soilHealthCardBg.png"))),
            ),
          ],
        ),
      ),
    );
  }
}
