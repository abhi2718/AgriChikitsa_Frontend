import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';

class FeaturesCard extends StatelessWidget {
  const FeaturesCard({super.key, required this.title, required this.image, required this.ontap});
  final String title;
  final String image;
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return InkWell(
      onTap: ontap,
      child: Container(
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
                imageUrl: image,
                fit: BoxFit.cover,
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
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500, fontSize: 28, color: AppColor.whiteColor),
                  ),
                  SizedBox(
                    height: title == "Soil Testing" || title == "मृदा परीक्षण" ? 8 : null,
                  ),
                  title == "Soil Testing" || title == "मृदा परीक्षण"
                      ? Row(
                          children: [
                            Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue("comingSoon")
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: const Color(0xffFFDE41)),
                            ),
                            //   const SizedBox(
                            //     width: 4,
                            //   ),
                            //   Text(
                            //     "20/12/2023",
                            //     style: GoogleFonts.montserrat(
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 13,
                            //         color: AppColor.whiteColor),
                            //   ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
