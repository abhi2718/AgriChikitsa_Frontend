import 'package:agriChikitsa/screens/tab.screens/hometab.screen/checkPrices.screen/checkPricesViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/text.widgets/text.dart';

class PricesScreen extends HookWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<CheckPricesModel>(context, listen: false));
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: const Icon(Icons.arrow_back)),
        title: const BaseText(
          // title: AppLocalizations.of(context)!.createPosthi,
          title: "Prices",
          style: TextStyle(
              color: AppColor.darkBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const BaseText(
              title: "Crop Prices",
              style: TextStyle(
                  color: AppColor.extraDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
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
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(18)),
                child: const Center(
                  child: BaseText(
                      title: "Uttar Pradesh", style: TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(18)),
                child: const Center(
                  child: BaseText(
                      title: "RaeBareli", style: TextStyle(fontSize: 15)),
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
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(18)),
                child: const Center(
                  child: BaseText(
                      title: "Sadar Mandi", style: TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                width: dimension['width']! * 0.40,
                height: dimension['height']! * 0.08,
                decoration: BoxDecoration(
                    color: AppColor.darkColor,
                    borderRadius: BorderRadius.circular(18)),
                child: const Center(
                  child: BaseText(
                      title: "Rice",
                      style:
                          TextStyle(fontSize: 15, color: AppColor.whiteColor)),
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
            decoration: BoxDecoration(
                color: Colors.yellow[400],
                borderRadius: BorderRadius.circular(18)),
            child: const Center(
              child: BaseText(
                  title: "Rice Price Details",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: Column(
              children: [
                ListTile(
                  tileColor: AppColor.whiteColor,
                  leading: Icon(
                    Icons.brightness_1,
                    color: AppColor.darkColor,
                  ),
                  title: BaseText(
                    title: "Minimum Price",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: BaseText(
                      title: "\u{20B9} 2175",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: AppColor.whiteColor,
                  leading: Icon(
                    Icons.brightness_1,
                    color: AppColor.errorColor,
                  ),
                  title: BaseText(
                    title: "Maximum Price",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: BaseText(
                      title: "\u{20B9} 2575",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
