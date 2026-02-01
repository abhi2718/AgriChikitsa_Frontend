import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/plotHistory.screen/plot_history_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlotHistoryScreen extends HookWidget {
  const PlotHistoryScreen({super.key, required this.selectedPlot});
  final Plots selectedPlot;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<PlotHistoryViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.getPlotHistory(context, selectedPlot.id);
    }, []);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("oldCropsBtn").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<PlotHistoryViewModel>(builder: (context, provider, child) {
        return provider.getHistoryLoader
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.darkColor,
                ),
              )
            : provider.plotHistory == null
                ? Center(
                    child: Text(AppLocalization.of(context)
                        .getTranslatedValue('noCropHistoryTitle')
                        .toString()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        provider.plotHistory.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            width: dimension['width']!,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: -7,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              provider.plotHistory[index]['cropImage']),
                                        ),
                                        const SizedBox(
                                          width: 14,
                                        ),
                                        Text(
                                          '${AppLocalization.of(context).getTranslatedValue('plotCropTitle')} - ${AppLocalization.of(context).locale.toString() == "en" ? provider.plotHistory[index]['cropName'] : provider.plotHistory[index]['cropNameHi']}',
                                          style: GoogleFonts.inter(
                                              fontSize: 16, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    provider.plotHistory[index]['isPresentCropHistory']
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(vertical: 10),
                                            width: 15,
                                            height: 15,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "${AppLocalization.of(context).getTranslatedValue('cropAddedTitle')} - ${DateFormat('MMMM d, yyyy').format(DateTime.parse(provider.plotHistory[index]['dateAdded']))}",
                                  style:
                                      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                provider.plotHistory[index]['isPresentCropHistory']
                                    ? const SizedBox.shrink()
                                    : Text(
                                        "${AppLocalization.of(context).getTranslatedValue('cropRemovedTitle')} - ${DateFormat('MMMM d, yyyy').format(DateTime.parse(provider.plotHistory[index]['dateRemoved']))}",
                                        style: GoogleFonts.inter(
                                            fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
      }),
    );
  }
}
