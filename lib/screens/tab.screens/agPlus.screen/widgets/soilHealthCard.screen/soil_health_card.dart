import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/soilHealthCard.screen/widgets/details_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/soilHealthCard.screen/widgets/helper/raise_request.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/soilHealthCard.screen/widgets/soil_testing_reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/utils.dart';
import '../../agPlus_view_model.dart';

class SoilHealthCard extends HookWidget {
  const SoilHealthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.requestStatus = false;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        foregroundColor: AppColor.whiteColor,
        backgroundColor: AppColor.extraDark,
        title: const Text(
          "Soil Health Card",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Integrated Nutrient Management",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700, color: AppColor.extraDark),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showRaiseRequest(context, dimension);
                  },
                  child: Container(
                    height: dimension["height"]! * 0.1,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        boxShadow: const [BoxShadow(offset: Offset(2, 3), color: Colors.grey)],
                        color: const Color(0xffBEDEB3),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "Raise a request for Soil Testing",
                      style: TextStyle(color: AppColor.darkBlackColor, fontSize: 16),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () => Utils.model(context, const SoilTestingReportScreen()),
                  child: Container(
                    height: dimension["height"]! * 0.1,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        boxShadow: const [BoxShadow(offset: Offset(2, 3), color: Colors.grey)],
                        color: const Color(0xffBEDEB3),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "Soil Testing Reports",
                      style: TextStyle(color: AppColor.darkBlackColor, fontSize: 16),
                    )),
                  ),
                ),
              ],
            ),
          ),
          const Align(
              alignment: Alignment.bottomCenter,
              child: Image(image: AssetImage("assets/images/soilHealthCardBg.png"))),
        ],
      ),
    );
  }
}
