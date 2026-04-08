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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.lightColor,
                            AppColor.whiteColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.extraDark.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: AppColor.lightColor,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Top Row: Market + Distance Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Market Name
                                Expanded(
                                  child: Text(
                                    mandi.market,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.extraDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                /// Distance Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.extraDark,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${mandi.distance} km",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            /// Price Row
                            Row(
                              children: [
                                /// Min Price Card
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColor.lightColor,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("minPrice")
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.midBlackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${mandi.minPrice}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.errorColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// Max Price Card
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.extraDark,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("maxPrice")
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${mandi.maxPrice}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// Arrival Date Chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.lightColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${AppLocalization.of(context).getTranslatedValue("arrival")}: ${_formatDate(mandi.arrivalDate)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.extraDark,
                                ),
                              ),
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
