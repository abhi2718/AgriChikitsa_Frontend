import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ReportPostScreen extends StatefulWidget {
  const ReportPostScreen({super.key, required this.userId, this.postId});
  final String userId;
  final String? postId;

  @override
  _ReportPostScreenState createState() => _ReportPostScreenState();
}

class _ReportPostScreenState extends State<ReportPostScreen> {
  String? selectedReason;
  String additionalInfo = '';

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Consumer<HomeTabViewModel>(builder: (context, provider, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 8,
        ),
        height: isKeyboardVisible ? dimension['height']! : dimension['height']! * 0.7,
        width: dimension['width'],
        child: provider.reportPostLoader
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.darkColor,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.horizontal_rule)),
                  Center(
                    child: Text(
                      AppLocalization.of(context).getTranslatedValue('reportPost').toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalization.of(context).getTranslatedValue("questionReport").toString(),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ReportReasonTile(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("spamReport1")
                                .toString(),
                            userId: widget.userId,
                            selectedReason: selectedReason,
                            onSelected: (reason) {
                              setState(() {
                                selectedReason = reason;
                              });
                            },
                          ),
                          ReportReasonTile(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("spamReport2")
                                .toString(),
                            userId: widget.userId,
                            selectedReason: selectedReason,
                            onSelected: (reason) {
                              setState(() {
                                selectedReason = reason;
                              });
                            },
                          ),
                          ReportReasonTile(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("spamReport3")
                                .toString(),
                            userId: widget.userId,
                            selectedReason: selectedReason,
                            onSelected: (reason) {
                              setState(() {
                                selectedReason = reason;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            maxLines: 5,
                            onChanged: (value) {
                              setState(() {
                                additionalInfo = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: AppLocalization.of(context)
                                  .getTranslatedValue("additionalReport")
                                  .toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: selectedReason == null
                        ? null
                        : () {
                            final reportDetails =
                                "$selectedReason ${additionalInfo.isNotEmpty ? "- $additionalInfo" : ""}";
                            provider.reportPost(reportDetails, widget.userId, widget.postId, context);
                          },
                    child: GradientButton(
                      height: dimension['height']! * 0.08,
                      width: dimension['width']!,
                      title:
                          AppLocalization.of(context).getTranslatedValue("submitButton").toString(),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

class ReportReasonTile extends StatelessWidget {
  const ReportReasonTile({
    Key? key,
    required this.title,
    required this.userId,
    required this.selectedReason,
    required this.onSelected,
  }) : super(key: key);

  final String title;
  final String userId;
  final String? selectedReason;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final isSelected = selectedReason == title;

    return GestureDetector(
      onTap: () {
        onSelected(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 40,
        width: dimension['width'],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
            Checkbox(
              value: isSelected,
              activeColor: AppColor.extraDark,
              onChanged: (value) {
                onSelected(title);
              },
            ),
          ],
        ),
      ),
    );
  }
}
