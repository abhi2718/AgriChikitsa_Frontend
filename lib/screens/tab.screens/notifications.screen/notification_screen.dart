import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/widgets/notification_tile.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../../res/color.dart';
import '../../../utils/utils.dart';
import '../../../widgets/text.widgets/text.dart';

class NotificationScreen extends HookWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel =
        useMemoized(() => Provider.of<NotificationViewModel>(context, listen: false));
    final scrollController = useScrollController();

    useEffect(() {
      useViewModel.fetchNotifications(context);
      return null;
    }, []);

    useEffect(() {
      void scrollListener() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!useViewModel.isFetchingMore && useViewModel.hasNextPage) {
            useViewModel.fetchMoreNotifications(context);
          }
        }
      }

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, [scrollController]);

    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        title: BaseText(
          title: AppLocalization.of(context).getTranslatedValue("notificationHeader").toString(),
          style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Remix.arrow_left_line,
            color: AppColor.darkBlackColor,
          ),
        ),
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, provider, child) {
          if (provider.loading && provider.notificationsList.isEmpty) {
            return ListView.builder(
              itemCount: 10,
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Skeleton(
                    height: dimension['height']! * 0.11,
                    width: dimension['width']!,
                    radius: 15,
                  ),
                );
              },
            );
          }

          if (!provider.loading && provider.notificationsList.isEmpty) {
            return RefreshIndicator(
              color: AppColor.extraDark,
              onRefresh: () async {
                await provider.fetchNotifications(context, isRefresh: true);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslatedValue("notificationEmpty")
                            .toString(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColor.extraDark,
            onRefresh: () async {
              await provider.fetchNotifications(context, isRefresh: true);
            },
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              itemCount: provider.notificationsList.length + (provider.isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.notificationsList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColor.extraDark,
                        ),
                      ),
                    ),
                  );
                }
                final notificationItem = provider.notificationsList[index];
                return NotificationTile(
                  key: ValueKey(notificationItem['_id'] ?? index),
                  notificationItem: notificationItem,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
