import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ndvi.screen/ndvi_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ndvi.screen/ndvi_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ndvi.screen/ndvi_video_player.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NDVIPromo extends HookWidget {
  const NDVIPromo({super.key, required this.selectedPlot});
  final Plots selectedPlot;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<NDVIViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.reinitialize();
      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("cropMonitoringTitle").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: NdviVideoPlayer(
                    videoUrl: "https://agrichikitsabucket.s3.ap-south-1.amazonaws.com/ndvi.mp4",
                    aspectRatio: 16 / 9,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: dimension['width']!,
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    AppLocalization.of(context)
                        .getTranslatedValue("ndviPromoDescription")
                        .toString(),
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
                            offset: Offset(0, 2),
                            color: Colors.black45,
                            blurRadius: 1,
                            spreadRadius: 0)
                      ]),
                  child: Row(
                    children: [
                      Image.asset("assets/images/farming.png"),
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("ndviAdvantages01")
                                    .toString(),
                                style: GoogleFonts.hind(fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("ndviAdvantages02")
                                    .toString(),
                                style: GoogleFonts.hind(fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("ndviAdvantages03")
                                    .toString(),
                                style: GoogleFonts.hind(fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 25,
                      spreadRadius: -7,
                      offset: const Offset(0, 10),
                    )
                  ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(AppLocalization.of(context)
                              .getTranslatedValue("addCropMonitoringQuestion")
                              .toString())),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.darkColor,
                            foregroundColor: AppColor.whiteColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 32),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final res =
                                await useViewModel.addFieldForMonitoring(context, selectedPlot.id);
                            if (!context.mounted) return;
                            if (res["success"]) {
                              selectedPlot.isMonitoringOpted = true;
                              selectedPlot.ndviId = res["ndviId"];
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  // Start the delayed pop and navigation here
                                  Future.delayed(const Duration(seconds: 3), () {
                                    Navigator.of(dialogContext).pop();
                                    Navigator.of(dialogContext).pop();
                                    Utils.model(
                                      context,
                                      NDVIScreen(
                                        selectedPlot: selectedPlot,
                                        ndviId: res["ndviId"],
                                      ),
                                    );
                                  });

                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Consumer<NDVIViewModel>(
                                      builder: (context, provider, child) {
                                        return Container(
                                          padding: const EdgeInsets.all(16.0),
                                          height: dimension["height"]! * 0.3,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.asset(
                                                  'assets/images/plot_success.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                AppLocalization.of(context)
                                                    .getTranslatedValue("addMonitoringSuccess")
                                                    .toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w400),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            AppLocalization.of(context).getTranslatedValue("yes").toString(),
                            style: const TextStyle(
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Overlay Loader
          Consumer<NDVIViewModel>(
            builder: (context, provider, child) {
              if (!provider.addForMonitoringLoader) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black54, // blackish overlay
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
