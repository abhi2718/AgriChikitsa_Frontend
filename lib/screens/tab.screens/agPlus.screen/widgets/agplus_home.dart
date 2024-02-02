import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/crop_report_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/features_card.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/pest_management.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/selected_plot_details.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/soilHealthCard.screen/soil_health_card.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/weather_card.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/widgets/weather_details_Screen.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../ag_plus_view_model.dart';
import '../weather.screen/weather_view_model.dart';
import '../helper/current_selected_plot.dart';

class AGPlusHome extends HookWidget {
  const AGPlusHome({super.key, required this.plotNumber});
  final int plotNumber;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    useEffect(() {
      weatherViewModel.getCurrentWeather(context, useViewModel.selectedPlot);
    }, [useViewModel.selectedPlot]);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: Column(
            children: [
              CurrentSelectedPlot(
                plotNumber: plotNumber,
                selectedPlot: useViewModel.selectedPlot,
              ),
              SelectedPlotDetails(
                selectedPlot: useViewModel.selectedPlot,
              ),
              Consumer<WeatherViewModel>(builder: (context, provider, child) {
                return provider.getWeatherDataLoader
                    ? Skeleton(height: dimension["height"]! * 0.3, width: dimension["width"]!)
                    : InkWell(
                        onTap: () =>
                            Utils.model(context, WeatherScreenDetails(useViewModel: provider)),
                        child: WeatherCard(
                            provider: provider, currentSelectedPlot: useViewModel.selectedPlot),
                      );
              }),
              FeaturesCard(
                  title:
                      AppLocalization.of(context).getTranslatedValue("soilTestingTitle").toString(),
                  image:
                      "https://images.unsplash.com/photo-1492496913980-501348b61469?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ontap: () {
                    Utils.toastMessage(
                        AppLocalization.of(context).getTranslatedValue("comingSoon").toString());
                    // Utils.model(context, const SoilHealthCard());
                  }),
              FeaturesCard(
                  title:
                      AppLocalization.of(context).getTranslatedValue("irrigationTitle").toString(),
                  image:
                      "https://images.unsplash.com/photo-1609583120830-7ede0764d401?q=80&w=1888&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ontap: () {
                    Utils.model(
                        context,
                        PestManagement(
                          isIrrigationCardTapped: true,
                          selectedPlots: useViewModel.selectedPlot,
                          agPlusViewModel: useViewModel,
                        ));
                  }),
              FeaturesCard(
                  title: AppLocalization.of(context)
                      .getTranslatedValue("pestManagementTitle")
                      .toString(),
                  image:
                      "https://images.unsplash.com/photo-1491723203629-ac87f78dc19b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ontap: () {
                    Utils.model(
                        context,
                        PestManagement(
                          isIrrigationCardTapped: false,
                          selectedPlots: useViewModel.selectedPlot,
                          agPlusViewModel: useViewModel,
                        ));
                  }),
              FeaturesCard(
                  title: AppLocalization.of(context).getTranslatedValue("cropReport").toString(),
                  image:
                      "https://images.unsplash.com/photo-1511735643442-503bb3bd348a?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ontap: () {
                    Utils.model(context, CropReportScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
