import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/widgets/old_expense_crop_basis.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/plotHistory.screen/plot_history_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
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
            : provider.plotHistory == null || provider.plotHistory.length == 1
                ? Center(
                    child: Text(AppLocalization.of(context)
                        .getTranslatedValue('noCropHistoryTitle')
                        .toString()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        provider.plotHistory.length,
                        (index) => provider.plotHistory[index]['isPresentCropHistory']
                            ? const SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  Utils.model(
                                      context,
                                      OldExpenseCropBasis(
                                          plotId: provider.plotHistory[index]['fieldRef'],
                                          cropHistoryId: provider.plotHistory[index]
                                              ['cropHistoryId'],
                                          cropName: provider.plotHistory[index]['cropName'],
                                          cropNameHi: provider.plotHistory[index]['cropNameHi'],
                                          selectedPlot: selectedPlot));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                  height: dimension['height']! * 0.22,
                                  width: dimension['width']!,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: provider.plotHistory[index]['cropImage'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Skeleton(
                                            height: dimension['height']! * 0.21,
                                            width: dimension['width']!,
                                            radius: 12,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Warning icon for no record here
                                      Positioned(
                                        top: 10,
                                        right: 20,
                                        child: provider.plotHistory[index]['kharchaKamaiRecord'] ==
                                                null
                                            ? Tooltip(
                                                message: AppLocalization.of(context)
                                                    .getTranslatedValue("noKharchaKamaiForCrop")
                                                    .toString(),
                                                triggerMode: TooltipTriggerMode.tap,
                                                verticalOffset: 20,
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: const Icon(
                                                  Icons.error,
                                                  color: AppColor.errorColor,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${AppLocalization.of(context).getTranslatedValue('plotCropTitle')} - ${AppLocalization.of(context).locale.toString() == "en" ? provider.plotHistory[index]['cropName'] : provider.plotHistory[index]['cropNameHi']}',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 28,
                                                  color: AppColor.whiteColor),
                                            ),
                                            Text(
                                              "${AppLocalization.of(context).getTranslatedValue(provider.plotHistory[index]['sowingDate'] != null ? 'sowingAddedTitle' : 'cropAddedTitle')} - ${DateFormat('MMMM d, yyyy').format(DateTime.parse("${provider.plotHistory[index]['sowingDate'] ?? provider.plotHistory[index]['dateAdded']}"))}",
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.whiteColor),
                                            ),
                                            Text(
                                              "${AppLocalization.of(context).getTranslatedValue('cropRemovedTitle')} - ${DateFormat('MMMM d, yyyy').format(DateTime.parse(provider.plotHistory[index]['dateRemoved']))}",
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.whiteColor),
                                            ),
                                          ],
                                        ),
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
