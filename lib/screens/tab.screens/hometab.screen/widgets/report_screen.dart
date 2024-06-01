import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      padding: const EdgeInsets.all(8),
      height: dimension['height']! * 0.7,
      width: dimension['width'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Icon(Icons.horizontal_rule)),
          Center(
              child: Text(
            AppLocalization.of(context).getTranslatedValue('reportPost').toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Why do you want to report this post?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          ReportReasonTile(
            title: "It's spam",
            userId: userId,
          ),
          ReportReasonTile(
            title: "Nudity or sexual activity",
            userId: userId,
          ),
          ReportReasonTile(
            title: "Hate speech or symbols",
            userId: userId,
          ),
        ],
      ),
    );
  }
}

class ReportReasonTile extends StatelessWidget {
  const ReportReasonTile({super.key, required this.title, required this.userId});
  final String title;
  final String userId;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        useViewModel.reportPost(title, userId, context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext dialogContext) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Consumer<HomeTabViewModel>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      height: dimension["height"]! * 0.3,
                      child: provider.reportPostLoader
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.extraDark,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                provider.reportPostStatus
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/plot_success.png',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Lottie.asset(
                                        'assets/lottie/fail.json',
                                        height: dimension['height']! * 0.10,
                                        width: dimension['width']! * 0.30,
                                      ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  provider.reportPostStatus
                                      ? "Thanks for reporting this post!"
                                      : "${AppLocalization.of(context).getTranslatedValue("oopsTitle").toString()} ${AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    );
                  },
                ),
              );
            });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 20,
          width: dimension['width'],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          )),
    );
  }
}
