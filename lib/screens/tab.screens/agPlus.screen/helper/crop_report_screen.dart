import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';

class CropReportScreen extends StatelessWidget {
  const CropReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("cropReport").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        height: dimension["height"]!,
        width: dimension["width"]!,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration:
            BoxDecoration(color: AppColor.whiteColor, borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CropReportCard(dimension: dimension),
              CropReportCard(dimension: dimension),
              CropReportCard(dimension: dimension),
              CropReportCard(dimension: dimension),
            ],
          ),
        ),
      ),
    );
  }
}

class CropReportCard extends StatelessWidget {
  const CropReportCard({
    super.key,
    required this.dimension,
  });

  final Map<String, double> dimension;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: dimension["height"]! * 0.20,
      width: dimension["width"]!,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Text(
              "Jan 22",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500, fontSize: 12, color: AppColor.cropReportTextColor),
            ),
          ),
          SizedBox(
            width: dimension["width"]! * 0.04,
          ),
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Week Nutrition Advisory",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, color: AppColor.darkBlackColor),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sit arcu aliquet ut dui egestas.",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColor.cropReportTextColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 28),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.iconColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "RainVideo.mp3",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
