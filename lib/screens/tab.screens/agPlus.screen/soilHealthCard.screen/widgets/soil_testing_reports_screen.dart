import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../res/color.dart';

class SoilTestingReportScreen extends HookWidget {
  const SoilTestingReportScreen({super.key, required this.fieldId});
  final String fieldId;
  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(() => Provider.of<AGPlusViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.getSoilReportsList(context, fieldId, 1);
    }, [fieldId]);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColor.darkBlackColor,
        elevation: 0.0,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("reportButton").toString(),
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
              !useViewModel.isReportsLoading &&
              useViewModel.currentReportsPage < useViewModel.totalReportsPages) {
            useViewModel.getSoilReportsList(context, fieldId, useViewModel.currentReportsPage++);
          }
          return false;
        },
        child: Consumer<AGPlusViewModel>(
          builder: (context, provider, child) {
            if (provider.isReportsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColor.extraDark));
            }
            if (provider.reportsList.isEmpty) {
              return Center(
                  child: Text(
                      AppLocalization.of(context).getTranslatedValue("noReportFound").toString()));
            }

            return ListView.builder(
              itemCount: provider.reportsList.length + (provider.isReportsLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.reportsList.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final report = provider.reportsList[index];
                return _buildReportTile(context, report);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportTile(BuildContext context, Map<String, dynamic> report) {
    final Map<String, String> statusHiMap = {
      "ACTIVE": "ऐक्टिव",
      "PENDING": "पेंडिंग",
      "TESTED": "परीक्षित",
      "INPROGRESS": "प्रगति में",
      "COMPLETED": "कंप्लीटएड",
    };

    final String testId = report['testId'];
    final String status = report['status'];
    final String displayStatus = AppLocalization.of(context).locale.toString() == "hi"
        ? statusHiMap[status] ?? status
        : status;
    final String cropName = report['cropName'];
    final String sampleDate = report['sampleDate'];
    final DateTime formattedDate = DateTime.parse(sampleDate);
    final String formattedDateString =
        DateFormat('dd/MM/yy h:mm a').format(formattedDate.toLocal());
    return InkWell(
      onTap: () => {
        if (status == 'TESTED')
          launchUrl(Uri.parse("https://agrichikitsa.org/public/soil-report/${report['_id']}"))
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(offset: Offset(2, 2), color: Colors.black45)],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColor.extraDark,
                    ),
                  ),
                  Text(
                    '${AppLocalization.of(context).getTranslatedValue("plotCropTitle").toString()}: $cropName',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalization.of(context).getTranslatedValue("requestGeneratedDate").toString()} : $formattedDateString',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (status == 'TESTED')
              RawMaterialButton(
                onPressed: () =>
                    {launchUrl(Uri.parse("https://agrichikitsa.org/soilreport/${report['_id']}"))},
                elevation: 2.0,
                fillColor: AppColor.extraDark,
                constraints: BoxConstraints(minHeight: 0, minWidth: 0),
                padding: EdgeInsets.all(12.0),
                shape: CircleBorder(),
                child: Icon(
                  Icons.description,
                  size: 22.0,
                  color: AppColor.whiteColor,
                ),
              )
            else
              Text(
                displayStatus,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }
}
