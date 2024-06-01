import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/mandiPrices.screen/mandi_prices_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/text.widgets/text.dart';

class PricesScreen extends HookWidget {
  final dynamic pricesData;
  const PricesScreen({super.key, required this.pricesData});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<MandiPricesModel>(context, listen: false));
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading:
            InkWell(onTap: () => useViewModel.goBack(context), child: const Icon(Icons.arrow_back)),
        title: BaseText(
          title: AppLocalization.of(context).getTranslatedValue("priceInfoTitle").toString(),
          style: GoogleFonts.inter(
              color: AppColor.darkBlackColor, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BaseText(
              title:
                  AppLocalization.of(context).getTranslatedValue("priceInfoSubheading").toString(),
              style: GoogleFonts.inter(
                  color: AppColor.extraDark, fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor, borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child:
                      BaseText(title: pricesData!['state'], style: const TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor, borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: BaseText(
                      title: pricesData!['district'], style: const TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor, borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child:
                      BaseText(title: pricesData!['market'], style: const TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.darkColor, borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: BaseText(
                      title: pricesData!['commodity'],
                      style: const TextStyle(fontSize: 15, color: AppColor.whiteColor)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: dimension['width']! * 0.90,
            height: dimension['height']! * 0.08,
            decoration:
                BoxDecoration(color: Colors.yellow[400], borderRadius: BorderRadius.circular(18)),
            child: Center(
              child: BaseText(
                  title:
                      "${pricesData!['commodity']} ${AppLocalization.of(context).getTranslatedValue("priceInfoTag").toString()}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: Column(
              children: [
                ListTile(
                  tileColor: AppColor.whiteColor,
                  leading: const Icon(
                    Icons.brightness_1,
                    color: AppColor.darkColor,
                  ),
                  title: BaseText(
                    title: AppLocalization.of(context).getTranslatedValue("minPrice").toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: BaseText(
                      title: "\u{20B9} ${pricesData!['min_price']}",
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: AppColor.whiteColor,
                  leading: const Icon(
                    Icons.brightness_1,
                    color: AppColor.errorColor,
                  ),
                  title: BaseText(
                    title: AppLocalization.of(context).getTranslatedValue("maxPrice").toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: BaseText(
                      title: "\u{20B9} ${pricesData!['max_price']}",
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
