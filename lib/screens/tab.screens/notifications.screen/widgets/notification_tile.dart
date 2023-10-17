import 'package:agriChikitsa/screens/tab.screens/notifications.screen/widgets/chat_history.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';
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
    void handleLike() {
      useViewModel.toggleNotifications(
          context, notificationItem["_id"], isRead.value);
      if (!isRead.value) {
        isRead.value = true;
      }
    }

    final notificationImage = notificationItem['imgurl'];
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 4),
      child: InkWell(
        onTap: () => handleLike(),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Expanded(
                child: ExpansionTile(
                  initiallyExpanded: isRead.value ? false : true,
                  textColor: AppColor.darkBlackColor,
                  childrenPadding: const EdgeInsets.only(
                      top: 2, left: 15, right: 15, bottom: 8),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: BaseText(
                        title: "जवाब : ${notificationItem['message']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    notificationItem['url'] != null
                        ? notificationItem != ""
                            ? Row(
                                children: [
                                  Text(AppLocalizations.of(context)!.linkhi,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  InkWell(
                                    onTap: () {
                                      launchUrl(
                                          Uri.parse(notificationItem['url']));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: dimension['width']! * 0.65,
                                      child: Text(
                                        "${notificationItem['url']}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.hyperlinkColor),
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
                    notificationImage != null
                        ? Container(
                            height: dimension['height']! * 0.30,
                            width: dimension['width']!,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: notificationImage,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Skeleton(
                                  height: dimension['height']! * 0.30,
                                  width: dimension['width']!,
                                  radius: 10,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Center(
                child: IconButton(
                  onPressed: () {
                    Utils.model(
                        context,
                        ChatHistory(
                          notificationItem: notificationItem,
                        ));
                  },
                  icon: const Icon(Icons.description),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
