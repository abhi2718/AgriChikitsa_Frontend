import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/helper/chat_description.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final dynamic notificationItem;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<NotificationViewModel>(context, listen: false));
    final isRead = useState(notificationItem['read']);
    void handleLike() {
      useViewModel.toggleNotifications(context, notificationItem["_id"], isRead.value);
      if (!isRead.value) {
        isRead.value = true;
      }
      final String eventType = notificationItem['eventType']?.toString() ?? '';
      final String category = notificationItem['category']?.toString() ?? '';
      final String relatedModel = notificationItem['relatedModel']?.toString() ?? '';
      final bool hasRelatedChat = notificationItem['relatedTo'] != null &&
          notificationItem['relatedTo'].toString().isNotEmpty;

      final bool canRedirect = hasRelatedChat &&
          (category == 'chat' ||
              eventType == 'CHAT_ADMIN_REPLY' ||
              eventType == 'ADMIN_REPLY' ||
              eventType == 'CHAT_QUERY_ASSIGNED' ||
              eventType == 'CHAT_MESSAGE' ||
              relatedModel == 'AdminChat' ||
              relatedModel == 'ChatHistorySchema');

      if (canRedirect) {
        Utils.model(
          context,
          ChatDescription(
            chat: notificationItem,
            isFromNotifications: true,
          ),
        );
      }
    }

    final notificationImage = notificationItem['imgurl'];
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 4),
      child: InkWell(
        onTap: () => handleLike(),
        child: Card(
          elevation: 0.0,
          clipBehavior: Clip.antiAlias,
          color: isRead.value ? const Color(0xFFF2F6F3) : AppColor.extraDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ExpansionTile(
            shape: const Border(),
            initiallyExpanded: isRead.value ? false : true,
            onExpansionChanged: (expanded) {
              handleLike();
            },
            textColor: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
            collapsedTextColor: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
            iconColor: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
            collapsedIconColor: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
            childrenPadding: const EdgeInsets.only(top: 2, left: 15, right: 15, bottom: 8),
            collapsedBackgroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: BaseText(
              title: notificationItem['title'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
              ),
            ),
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                thickness: 1.2,
                color: isRead.value ? AppColor.notificationBgColor : AppColor.whiteColor.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: BaseText(
                  title:
                      "${AppLocalization.of(context).getTranslatedValue("notificationReplyHeader").toString()} ${notificationItem['message']}",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
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
                            Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("notificationLink")
                                    .toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isRead.value ? AppColor.darkBlackColor : AppColor.whiteColor,
                                )),
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  launchUrl(Uri.parse(notificationItem['url']));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: notificationImage,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Skeleton(
                            height: dimension['height']! * 0.30,
                            width: dimension['width']!,
                            radius: 10,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
