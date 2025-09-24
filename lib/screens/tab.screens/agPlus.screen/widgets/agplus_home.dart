import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/main.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/features_card.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/selected_plot_details.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ndvi.screen/ndvi_promo.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ndvi.screen/ndvi_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/pestAndDiseaseScreen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/plotHistory.screen/plot_history.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/soilHealthCard.screen/soil_health_card.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/weather_card.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/widgets/weather_details_Screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weedProtection.screen/weed_protection.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/crop.helpers/add_sowing_date.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/color.dart';
import '../ag_plus_view_model.dart';
import '../weather.screen/weather_view_model.dart';
import '../helper/current_selected_plot.dart';

class AGPlusHome extends HookWidget {
  const AGPlusHome({super.key, required this.plotNumber});
  final int plotNumber;

  Future<void> checkSowingDateAndShowDialogIfNeeded(
      BuildContext context, Plots selectedPlot, Map<String, double> dimension) async {
    if (selectedPlot.sowingDate != null) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = "dialog_shown_${selectedPlot.id}";
    final lastShownString = prefs.getString(key);

    if (lastShownString != null) {
      final lastShownDate = DateTime.tryParse(lastShownString);
      if (lastShownDate != null &&
          lastShownDate.year == today.year &&
          lastShownDate.month == today.month &&
          lastShownDate.day == today.day) {
        return;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          AppLocalization.of(context).getTranslatedValue("reminderPopupTitle").toString(),
        ),
        content: Text(
          AppLocalization.of(context).getTranslatedValue("reminderPopupDescription").toString(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              AppLocalization.of(context).getTranslatedValue("no").toString(),
              style: const TextStyle(color: AppColor.errorColor),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(ctx).pop();
              Utils.model(context, AddSowingDate(fieldId: selectedPlot.id));
            },
            child: GradientButton(
              height: dimension['height']! * 0.07,
              width: dimension['width']! * 0.2,
              title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
            ),
          ),
        ],
      ),
    );

    await prefs.setString(key, today.toIso8601String());
  }

  void warningPopups(BuildContext context, String cardName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        title: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              AppLocalization.of(context).getTranslatedValue("reminderPopupTitle").toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          AppLocalization.of(context).getTranslatedValue("${cardName}PopUpDescription").toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    final lang = AppLocalization.of(context).locale.toString();
    useEffect(() {
      weatherViewModel.getCurrentWeather(context, useViewModel.selectedPlot, lang);
      checkSowingDateAndShowDialogIfNeeded(context, useViewModel.selectedPlot, dimension);
    }, [useViewModel.selectedPlot]);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: useViewModel.selectedPlot == null
          ? AppBar(
              automaticallyImplyLeading: false,
            )
          : AppBar(
              backgroundColor: AppColor.whiteColor,
              foregroundColor: AppColor.darkBlackColor,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                AppLocalization.of(context).getTranslatedValue("agPlusHome").toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                      onTap: () => showDeleteFieldDialog(context, useViewModel),
                      child: const Icon(Icons.delete)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                              builder: (context) => PlotHistoryScreen(
                                    selectedPlot: useViewModel.selectedPlot,
                                  ))),
                      child: const Icon(Icons.history)),
                )
              ],
            ),
      body: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
        return provider.selectedPlot == null
            ? Container(
                height: dimension["height"],
                color: AppColor.whiteColor,
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, bottom: 16),
                  child: Column(
                    children: [
                      // useViewModel.selectedPlot["is_ndvi_opted"] ? :
                      CurrentSelectedPlot(
                        plotNumber: plotNumber,
                        selectedPlot: useViewModel.selectedPlot,
                      ),
                      SelectedPlotDetails(
                        selectedPlot: provider.selectedPlot,
                      ),
                      Consumer<WeatherViewModel>(builder: (context, provider, child) {
                        return provider.getWeatherDataLoader
                            ? Skeleton(
                                height: dimension["height"]! * 0.3, width: dimension["width"]!)
                            : InkWell(
                                onTap: () => Utils.model(
                                    context, WeatherScreenDetails(useViewModel: provider)),
                                child: WeatherCard(
                                    provider: provider,
                                    currentSelectedPlot: useViewModel.selectedPlot),
                              );
                      }),
                      FeaturesCard(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("weedProtectionTitle")
                              .toString(),
                          image:
                              "https://i0.wp.com/geopard.tech/wp-content/uploads/2022/03/19.2-min.jpg?resize=1024%2C555&ssl=1",
                          ontap: () {
                            // Utils.toastMessage(
                            //     AppLocalization.of(context).getTranslatedValue("comingSoon").toString());
                            Utils.model(context, const WeedCategorySelectModal());
                          }),

                      //To be implemented in v2.0
                      // FeaturesCard(
                      //     title:
                      //         AppLocalization.of(context).getTranslatedValue("agristickTitle").toString(),
                      //     image:
                      //         "https://images.pexels.com/photos/612335/pexels-photo-612335.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                      //     ontap: () {
                      //       // Utils.toastMessage(
                      //       //     AppLocalization.of(context).getTranslatedValue("comingSoon").toString());
                      //       Utils.model(
                      //           context,
                      //           AgriStickScreen(
                      //             currentSelectedPlot: useViewModel.selectedPlot,
                      //             agPlusViewModel: useViewModel,
                      //           ));
                      //     }),
                      FeaturesCard(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("soilTestingTitle")
                              .toString(),
                          image:
                              "https://images.unsplash.com/photo-1492496913980-501348b61469?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ontap: () {
                            // Utils.toastMessage(
                            //     AppLocalization.of(context).getTranslatedValue("comingSoon").toString());
                            Utils.model(context, const SoilHealthCard());
                          }),
                      FeaturesCard(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("cropMonitoringTitle")
                              .toString(),
                          image: "assets/images/ndvi_banner2.jpeg",
                          ontap: () {
                            if (useViewModel.selectedPlot.sowingDate == null) {
                              warningPopups(context, "ndvi");
                            } else {
                              Utils.model(
                                  context,
                                  useViewModel.selectedPlot.isMonitoringOpted
                                      ? NDVIScreen(
                                          selectedPlot: useViewModel.selectedPlot,
                                        )
                                      : NDVIPromo(selectedPlot: useViewModel.selectedPlot));
                            }
                          }),
                      // To be implemented v2.0
                      // FeaturesCard(
                      //     title:
                      //         AppLocalization.of(context).getTranslatedValue("irrigationTitle").toString(),
                      //     image:
                      //         "https://images.unsplash.com/photo-1609583120830-7ede0764d401?q=80&w=1888&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      //     ontap: () {
                      //       Utils.model(
                      //           context,
                      //           PestManagement(
                      //             isIrrigationCardTapped: true,
                      //             selectedPlots: useViewModel.selectedPlot,
                      //             agPlusViewModel: useViewModel,
                      //           ));
                      //     }),
                      FeaturesCard(
                          title: AppLocalization.of(context)
                              .getTranslatedValue("pestAndDiseaseTitle")
                              .toString(),
                          image:
                              "https://images.unsplash.com/photo-1491723203629-ac87f78dc19b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ontap: () {
                            if (useViewModel.selectedPlot.sowingDate == null) {
                              warningPopups(context, "pestDisease");
                            } else {
                              Utils.model(context, const PestAndDiseaseSelectModal());
                            }
                          }),
                      // FeaturesCard(
                      //     title: AppLocalization.of(context).getTranslatedValue("cropReport").toString(),
                      //     image:
                      //         "https://images.unsplash.com/photo-1511735643442-503bb3bd348a?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      //     ontap: () {
                      //       Utils.model(context, CropReportScreen());
                      //       Utils.model(context, CropReportScreen());
                      //       // Utils.toastMessage(
                      //       //     AppLocalization.of(context).getTranslatedValue("comingSoon").toString());
                      //     }),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
