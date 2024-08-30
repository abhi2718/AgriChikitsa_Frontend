import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportPostScreen extends StatefulWidget {
  @override
  _ReportPostScreenState createState() => _ReportPostScreenState();
  const ReportPostScreen({super.key, required this.userId});
  final String userId;
}

class _ReportPostScreenState extends State<ReportPostScreen> {
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);

    return Consumer<HomeTabViewModel>(builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.all(8),
        height: dimension['height']! * 0.7,
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
                    userId: widget.userId,
                    selectedReason: selectedReason,
                    onSelected: (reason) {
                      setState(() {
                        selectedReason = reason;
                      });
                    },
                  ),
                  ReportReasonTile(
                    title: "Nudity or sexual activity",
                    userId: widget.userId,
                    selectedReason: selectedReason,
                    onSelected: (reason) {
                      setState(() {
                        selectedReason = reason;
                      });
                    },
                  ),
                  ReportReasonTile(
                    title: "Hate speech or symbols",
                    userId: widget.userId,
                    selectedReason: selectedReason,
                    onSelected: (reason) {
                      setState(() {
                        selectedReason = reason;
                      });
                    },
                  ),
                  const Spacer(),
                  // child: ElevatedButton(
                  // onPressed: selectedReason == null
                  //     ? null
                  //     : () {
                  //         // Handle submit action here
                  //         final useViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
                  //         useViewModel.reportPost(selectedReason!, widget.userId, context);
                  //         // You can show the dialog here or wherever appropriate
                  //       },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  //     backgroundColor:
                  //         selectedReason == null ? Colors.grey : Theme.of(context).primaryColor,
                  //   ),
                  //   child: Text(
                  //     "Submit",
                  //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  InkWell(
                      onTap: selectedReason == null
                          ? null
                          : () {
                              provider.reportPost(selectedReason!, widget.userId, context);
                            },
                      child: GradientButton(
                          height: dimension['height']! * 0.08,
                          width: dimension['width']!,
                          title: AppLocalization.of(context)
                              .getTranslatedValue("submitButton")
                              .toString())),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: isSelected,
              activeColor: AppColor.extraDark,
              onChanged: (value) {
                onSelected(title);
              },
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
