import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../notification_view_model.dart';

class NotificationTile extends HookWidget {
  const NotificationTile({
    super.key,
    required this.notificationItem,
  });

  final notificationItem;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<NotificationViewModel>(context, listen: false));
    final isRead = useState(notificationItem['read']);
    // print(isRead.value);
    void handleLike() {
      useViewModel.toggleNotifications(
          context, notificationItem["_id"], isRead.value);
      if (!isRead.value) {
        isRead.value = true;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 4),
      child: InkWell(
        onTap: () => handleLike(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ExpansionTile(
            initiallyExpanded: isRead.value ? false : true,
            // collapsedIconColor: AppColor.whiteColor,
            // iconColor: AppColor.whiteColor,
            textColor: AppColor.darkBlackColor,
            childrenPadding:
                const EdgeInsets.only(top: 2, left: 15, right: 15, bottom: 8),
            collapsedBackgroundColor: AppColor.whiteColor,
            backgroundColor: AppColor.whiteColor,
            title: BaseText(
              title: notificationItem['title'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(
                thickness: 1.2,
                color: AppColor.notificationBgColor,
              ),
              BaseText(
                title: "Reply : ${notificationItem['message']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              notificationItem['url'] != null
                  ? notificationItem != ""
                      ? Row(
                          children: [
                            const Text("Link : ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            InkWell(
                              onTap: () {
                                final splitUrl =
                                    notificationItem['url'].split('//');
                                final protocol = splitUrl[0].split(':')[0];
                                final domainSplit = splitUrl[1].split('/');
                                final path =
                                    splitUrl[1].split('${domainSplit[0]}/')[1];
                                useViewModel.openLink(
                                    context, protocol, domainSplit[0], path);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                width: dimension['width']! * 0.75,
                                child: Text(
                                  "${notificationItem['url']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                  textWidthBasis: TextWidthBasis.parent,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container()
                  : Container(),
              const SizedBox(
                height: 4,
              ),
              notificationItem['imgurl'] != null
                  ? Container(
                      height: dimension['height']! * 0.30,
                      width: dimension['width']!,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            notificationItem['imgurl'],
                            fit: BoxFit.cover,
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}