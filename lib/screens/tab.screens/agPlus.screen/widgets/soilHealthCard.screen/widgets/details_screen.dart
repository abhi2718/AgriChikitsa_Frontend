import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/soilHealthCard.screen/widgets/helper/field_details.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/soilHealthCard.screen/widgets/helper/report_table.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/soilHealthCard.screen/widgets/helper/solution_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../utils/utils.dart';

class DetailsScreen extends HookWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColor.darkBlackColor,
        elevation: 0.0,
        title: const Text(
          "Soil Health Card",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: dimension["width"],
        color: AppColor.notificationBgColor,
        child: Container(
          height: dimension['height'],
          margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          decoration: const BoxDecoration(
              color: Color(0xffFFF7D2),
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FieldDetails(),
                ReportTable(),
                Text(
                  "Solution / Advice",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SolutionTable()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
