import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import 'details_screen.dart';

class SoilTestingReportScreen extends StatelessWidget {
  const SoilTestingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColor.darkBlackColor,
        elevation: 0.0,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("reportButton").toString(),
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: dimension["height"],
        color: AppColor.notificationBgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: dimension["height"]! * 0.1,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(offset: Offset(2, 2), color: Colors.black45)],
                  color: AppColor.whiteColor,
                ),
                child: InkWell(
                  onTap: () => Utils.model(context, const DetailsScreen()),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Report 1",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Icon(Icons.description),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
