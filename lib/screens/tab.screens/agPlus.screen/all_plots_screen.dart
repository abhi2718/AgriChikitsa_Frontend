import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agplus_home.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/take_photo_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../utils/utils.dart';
import '../../../widgets/skeleton/skeleton.dart';
import 'widgets/gradient_button.dart';

class AllPlotsScreen extends HookWidget {
  const AllPlotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.getFields(context);
    }, []);
    return Scaffold(
      backgroundColor: AppColor.lightColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("yourPlotsHeader").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<AGPlusViewModel>(
        builder: (context, provider, child) {
          return provider.getFieldLoader
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.darkColor,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    provider.userPlotList.isEmpty
                        ? InkWell(
                            onTap: () {
                              provider.resetLoader();
                              takeAPhotoDialog(context, dimension, provider);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                              height: dimension['height']! * 0.25,
                              width: dimension['width']!,
                              decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade500, spreadRadius: 0, blurRadius: 5)
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColor.darkColor,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("addFirstPlot")
                                        .toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Column(
                                  children: [
                                    // ...provider.userPlotList.map((plot) {
                                    ...provider.userPlotList.asMap().entries.map((plot) {
                                      return Container(
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                                        height: dimension['height']! * 0.25,
                                        width: dimension['width']!,
                                        decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade500,
                                                  spreadRadius: 0,
                                                  blurRadius: 5)
                                            ]),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) => Skeleton(
                                                  height: dimension['height']! * 0.25,
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
                                                    Radius.circular(15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text(
                                                    "${AppLocalization.of(context).getTranslatedValue("plotCountTitle").toString()} ${plot.key + 1} ${plot.value.fieldName}",
                                                    // plot.fieldName,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColor.whiteColor),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "${AppLocalization.of(context).getTranslatedValue("plotCropTitle").toString()} - ${AppLocalization.of(context).locale.toString() == 'en' ? plot.value.cropName : plot.value.cropNameHi}",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColor.whiteColor),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    provider.setSelectedField(plot.value);
                                                    Utils.model(
                                                        context,
                                                        AGPlusHome(
                                                          plotNumber: plot.key + 1,
                                                        ));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin: const EdgeInsets.symmetric(
                                                        horizontal: 124, vertical: 4),
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: AppColor.whiteColor,
                                                        borderRadius: BorderRadius.circular(25)),
                                                    child: Text(
                                                      AppLocalization.of(context)
                                                          .getTranslatedValue("goButton")
                                                          .toString(),
                                                      style: GoogleFonts.inter(
                                                          color: Color(0xff383737),
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    InkWell(
                      onTap: () async {
                        if (await provider.checkPremium(context)) {
                          provider.resetLoader();
                          takeAPhotoDialog(context, dimension, provider);
                        }
                      },
                      child: Container(
                        margin: provider.userPlotList.isNotEmpty ? EdgeInsets.all(16) : null,
                        // margin: false ? EdgeInsets.all(16) : null,
                        child: GradientButton(
                          height: dimension['height']! * 0.10,
                          width: dimension['width']!,
                          title: AppLocalization.of(context)
                              .getTranslatedValue("addMorePlotButton")
                              .toString(),
                          icon: Icons.add_circle_outline,
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
