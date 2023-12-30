import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../model/plots.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';

class CurrentSelectedPlot extends StatelessWidget {
  const CurrentSelectedPlot({super.key, required this.selectedPlot, required this.plotNumber});
  final Plots selectedPlot;
  final int plotNumber;
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
                  "https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
                  "${AppLocalization.of(context).getTranslatedValue("plotCountTitle").toString()} ${plotNumber.toString()}",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, fontSize: 28, color: AppColor.whiteColor),
                ),
                Text(
                  selectedPlot.fieldName,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500, fontSize: 18, color: AppColor.whiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalization.of(context).getTranslatedValue("enterSoilType").toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: const Color(0xffFFDE41)),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      selectedPlot.soilType,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.whiteColor),
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
