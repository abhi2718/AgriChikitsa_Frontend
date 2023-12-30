import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agristick.screen/agristick_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agristick.screen/widgets/date_picker.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agristick.screen/widgets/graph.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';

class AgriStickScreen extends HookWidget {
  const AgriStickScreen(
      {super.key, required this.currentSelectedPlot, required this.agPlusViewModel});
  final Plots currentSelectedPlot;
  final AGPlusViewModel agPlusViewModel;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AgristickViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.reinitialize();
    }, [agPlusViewModel.selectedPlot]);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          currentSelectedPlot.agristick == null
              ? AppLocalization.of(context).getTranslatedValue("agristickTitle").toString()
              : AppLocalization.of(context).getTranslatedValue("agristickHomeTitle").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<AgristickViewModel>(builder: (context, provider, child) {
        return provider.scanBarCodeLoader
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.extraDark,
                ),
              )
            : currentSelectedPlot.agristick == null
                ? Container(
                    margin: const EdgeInsets.all(28),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/agristickHome.png"),
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("agristickSubtitle")
                              .toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        ),
                        Center(
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => const LinearGradient(stops: [
                              0.3,
                              0.8,
                              1
                            ], colors: [
                              Color(0xff0A4428),
                              Color(0xff10C52F),
                              Color(0xff12FF32)
                            ]).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("agristickTagline")
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25,
                                )),
                          ),
                        ),
                        Image.asset("assets/images/smartFarm.png"),
                        CustomElevatedButton(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("addDevice")
                              .toString(),
                          onPress: () {
                            provider.scanQRCode(context, currentSelectedPlot);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          provider.barCodeResult,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: dimension['width'],
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DatePicker(),
                                  SoilHealthChart(
                                    useViewModel: provider,
                                    selectedField: currentSelectedPlot,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
      }),
    );
  }
}
