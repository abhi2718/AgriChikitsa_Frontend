import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../model/plots.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';

class SelectedPlotDetails extends StatelessWidget {
  const SelectedPlotDetails({super.key, required this.selectedPlot});
  final Plots selectedPlot;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: dimension['height']! * 0.21,
      width: dimension['width']!,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl:
                  "https://images.unsplash.com/photo-1593738226658-f3e01177c3f0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.fill,
              placeholder: (context, url) => Skeleton(
                height: dimension['height']! * 0.21,
                width: dimension['width']!,
                radius: 12,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "Paddy",
                  AppLocalization.of(context).locale.toString() == "en"
                      ? selectedPlot.cropName
                      : selectedPlot.cropNameHi,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, fontSize: 28, color: AppColor.whiteColor),
                ),
                Text(
                  "${AppLocalization.of(context).getTranslatedValue("area").toString()} : ${selectedPlot.area}",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500, fontSize: 18, color: AppColor.whiteColor),
                ),
                Row(
                  children: [
                    Text(
                      AppLocalization.of(context).getTranslatedValue("dateOfPlantation").toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: const Color(0xffFFDE41)),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      selectedPlot.sowingDate ??
                          AppLocalization.of(context)
                              .getTranslatedValue("notPlantedYet")
                              .toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 12, color: AppColor.whiteColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
