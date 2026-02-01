import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class NearbyMandisScreen extends HookWidget {
  NearbyMandisScreen({super.key, required this.selectedPlot});
  Plots selectedPlot;

  Widget _priceText(String label, int price) {
    return Text(
      "$label: ₹$price",
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return "N/A";
    final parsed = DateTime.parse(date).toLocal();
    return "${parsed.day.toString().padLeft(2, '0')}-"
        "${parsed.month.toString().padLeft(2, '0')}-"
        "${parsed.year}";
  }

  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.clearNearbyMandis();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.getNearbyMandi(context, selectedPlot.cropId!);
      });
      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.notificationBgColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalization.of(context).getTranslatedValue("nearbyMandis").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
      ),
      body: Consumer<AGPlusViewModel>(
        builder: (context, provider, child) {
          if (provider.isNearbyMandiDataLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.extraDark,
              ),
            );
          }

          if (provider.nearbyMandis.isEmpty) {
            return Center(
              child: Text(
                AppLocalization.of(context).getTranslatedValue("noNearbyMandiData").toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Column(
            children: [
              Center(
                child: Text(
                  "${AppLocalization.of(context).locale.toString() == "en" ? selectedPlot.cropName : selectedPlot.cropNameHi} ${AppLocalization.of(context).getTranslatedValue("cropRateTitle").toString()}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.nearbyMandis.length,
                  itemBuilder: (context, index) {
                    final mandi = provider.nearbyMandis[index];

                    return Card(
                      color: AppColor.whiteColor,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Commodity
                                Text(
                                  mandi.market,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pin_drop,
                                      color: AppColor.extraDark,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${mandi.distance.toString()} km",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _priceText(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("minPrice")
                                            .toString(),
                                        mandi.minPrice),
                                    const SizedBox(width: 16),
                                    _priceText(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("maxPrice")
                                            .toString(),
                                        mandi.maxPrice),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// Arrival date
                                Text(
                                  "${AppLocalization.of(context).getTranslatedValue("arrival").toString()}: ${_formatDate(mandi.arrivalDate)}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
