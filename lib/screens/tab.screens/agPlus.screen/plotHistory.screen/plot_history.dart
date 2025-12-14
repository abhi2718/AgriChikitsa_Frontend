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
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("plotHistoryTitle").toString(),
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
                : Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://images.pexels.com/photos/461960/pexels-photo-461960.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: dimension['height']! * 0.30,
                        ),
                      ),
                      Positioned(
                        top: 200,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.only(top: 32, bottom: 16),
                          height: dimension['height']! - 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.extraDark,
                                      foregroundColor: AppColor.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(selectedPlot.area),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffA28A1C),
                                      foregroundColor: AppColor.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                        '${AppLocalization.of(context).getTranslatedValue('plotCropTitle')} - ${AppLocalization.of(context).locale.toString() == "en" ? selectedPlot.cropName : selectedPlot.cropNameHi}'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                      provider.plotHistory.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
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
                                                            provider.plotHistory[
                                                                provider.plotHistory.length -
                                                                    index -
                                                                    1]['cropRef']['image']),
                                                      ),
                                                      const SizedBox(
                                                        width: 14,
                                                      ),
                                                      Text(
                                                        '${AppLocalization.of(context).getTranslatedValue('plotCropTitle')} - ${AppLocalization.of(context).locale.toString() == "en" ? provider.plotHistory[provider.plotHistory.length - index - 1]['cropRef']['name'] : provider.plotHistory[provider.plotHistory.length - index - 1]['cropRef']['name_hi']}',
                                                        style: GoogleFonts.inter(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                  provider.plotHistory[provider.plotHistory.length -
                                                          index -
                                                          1]['isPresentCropHistory']
                                                      ? Container(
                                                          margin: const EdgeInsets.symmetric(
                                                              vertical: 10),
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
                                                "${AppLocalization.of(context).getTranslatedValue('cropAddedTitle')} - ${DateFormat('MMMM d, yyyy').format(DateTime.parse(provider.plotHistory[provider.plotHistory.length - index - 1]['dateAdded']))}",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14, fontWeight: FontWeight.w500),
                                              ),
                                              provider.plotHistory[provider.plotHistory.length -
                                                      index -
                                                      1]['isPresentCropHistory']
                                                  ? const SizedBox.shrink()
                                                  : Text(
                                                      "${AppLocalization.of(context).getTranslatedValue('cropRemovedTitle')} - ${DateFormat('MMMM d, yyyy').format(DateTime.parse(provider.plotHistory[provider.plotHistory.length - index - 1]['dateRemoved']))}",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
      }),
    );
  }
}
