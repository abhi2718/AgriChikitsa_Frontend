import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import '../../../../res/color.dart';
import '../../../../widgets/card.widgets/card.dart';

class HistoryCard extends HookWidget {
  dynamic data;
  HistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    DateTime createdAt = DateTime.parse(data['createdAt']);
    int day = createdAt.day;
    int month = createdAt.month;
    int year = createdAt.year;

    return Column(
      children: [
        LightContainer(
          child: SizedBox(
            height: 250,
            width: dimension["width"]! - 60,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WhiteContainer(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/group.png",
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            SubHeadingText(data["groupName"]),
                          ],
                        ),
                      ),
                      SubHeadingText('Vehicle ID: ${data["vehicleID"]}')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColor
                            .darkColor, // specify your desired color here
                        width: 2.0, // specify the width of the border
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ParagraphHeadingText(
                        "Task Details:",
                        textAlign: TextAlign.start,
                      ),
                      ParagraphHeadingText(
                        '$day/$month/$year',
                        textAlign: TextAlign.start,
                      ),
                    ]),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ParagraphText(
                          data["descripation"],
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: ParagraphText(data["status"]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
