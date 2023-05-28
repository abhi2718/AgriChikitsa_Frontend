import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../res/color.dart';
import '../../../../services/socket_io.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/card.widgets/card.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../hometab_view_model.dart';

class TaskCard extends HookWidget {
  dynamic assignedTasks;
  SocketService socketService;
  TaskCard(
      {super.key, required this.assignedTasks, required this.socketService});

  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    return LightContainer(
      child: SizedBox(
        height: 300,
        width: double.infinity,
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
                        SubHeadingText(assignedTasks["groupName"]),
                      ],
                    ),
                  ),
                  SubHeadingText('Vehicle ID: ${assignedTasks["vehicleID"]}'),
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
                    color:
                        AppColor.darkColor, // specify your desired color here
                    width: 2.0, // specify the width of the border
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const ParagraphHeadingText(
                "Task Details :",
                textAlign: TextAlign.start,
              ),
              ParagraphHeadingText(
                'Status : ${assignedTasks["status"]}',
                textAlign: TextAlign.start,
              )
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
                      assignedTasks["descripation"],
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  assignedTasks["status"] == "Assigned"
                      ? CustomElevatedButton(
                          title: "Done",
                          height: 40,
                          onPress: () =>
                              useViewModel.handleChangeAssignedTaskStatus(
                                  context, socketService),
                          width: 100,
                        )
                      : OutlinedButton(
                          onPressed: () {},
                          child: ParagraphText(assignedTasks["status"]),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
