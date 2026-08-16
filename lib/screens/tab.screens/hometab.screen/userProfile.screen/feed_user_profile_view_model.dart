import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/repository/feed_profile.repo/feed_profile_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FeedUserProfileViewModel extends ChangeNotifier {
  final _feedProfileRepository = FeedProfileRepository();
  late TabController tabController;
  dynamic feedList = [];
  dynamic connections;
  bool isFollowing = false;
  List<String> expandedPosts = [];
  bool isLoading = false;
  void disposeValues() {
    tabController.dispose();
    feedList.clear();
    isLoading = false;
    isFollowing = false;
    expandedPosts.clear();
    connections = null;
  }

  void setloading(value) {
    isLoading = value;
  }

  bool isExpanded(String id) {
    return expandedPosts.contains(id);
  }

  void toggleExpand(String id) {
    expandedPosts.add(id);
    notifyListeners();
  }

  String getTimeAgo(String dateString, BuildContext context) {
    DateTime createdAt = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    Duration difference = now.difference(createdAt);
    int daysDifference = difference.inDays;
    final bool isEnglish = AppLocalization.of(context).locale.toString() == 'en';
    if (daysDifference < 1) {
      int hoursDifference = difference.inHours;
      if (hoursDifference < 1) {
        int minutesDifference = difference.inMinutes;
        return '$minutesDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('mintueFeed')}${minutesDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('mintueFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
      } else {
        return '$hoursDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('hourFeed')}${hoursDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('hourFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
      }
    } else if (daysDifference < 31) {
      return '$daysDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('daysFeed')}${daysDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('daysFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
    } else {
      int monthsDifference = (daysDifference / 30).floor();
      return '$monthsDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('monthsFeed')}${monthsDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('monthsFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
    }
  }

  void fetchUserFeeds(BuildContext context, String userId) async {
    expandedPosts.clear();
    feedList.clear();
    connections = null;
    setloading(true);
    try {
      final data = await _feedProfileRepository.fetchPosts(userId);
      feedList = data['feeds'];
      isFollowing = data['isFollowing'];
      connections = data['connections'];
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      notifyListeners();
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void followUser(BuildContext context, String userId) async {
    setloading(true);
    notifyListeners();
    try {
      dynamic payload = {'profileUserId': userId};
      await _feedProfileRepository.followUser(payload);
      isFollowing = !isFollowing;
      setloading(false);
      fetchUserFeeds(context, userId);
    } catch (error) {
      setloading(false);
      notifyListeners();
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }
}
