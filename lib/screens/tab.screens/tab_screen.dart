import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_landing.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import './hometab.screen/hometab.dart';
import './profiletab.screen/profiletab.dart';
import './hometab.screen/createPost.screen/create_post_model.dart';
import '../../res/color.dart';
import 'chattab.screen/chattab.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    List<Widget> tabs = [
      const HomeTabScreen(),
      const JankariHomeTab(),
      const AGPlusLanding(),
      const ProfileTabScreen()
    ];

    Future<bool> _onWillPop() async {
      if (currentIndex.value != 0) {
        currentIndex.value = 0;
        return false; // Prevents the default back button behavior
      }
      return true; // Allows the default back button behavior (exit app)
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Column(
          children: [
            Consumer<CreatePostModel>(
              builder: (context, postModel, child) {
                if (postModel.isUploading) {
                  final pct = (postModel.uploadProgress * 100).toInt();
                  return SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: AppColor.extraDark,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              value: postModel.uploadProgress > 0 ? postModel.uploadProgress : null,
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Uploading post... $pct%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (postModel.isUploadSuccess) {
                  return SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.green.shade700,
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Post uploaded successfully!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (postModel.isUploadError) {
                  return SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.red.shade700,
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Upload failed. Please try again.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(child: tabs[currentIndex.value]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.white,
            elevation: 10.0,
            child: Image.asset(
              "assets/images/logoagrichikitsa.png",
              height: 40,
              width: 40,
            ),
            onPressed: () {
              // Utils.model(context, const ChatTabScreen());
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const ChatTabScreen()));
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 6.0,
          color: AppColor.notificationBgColor,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          height: 60,
          child: SizedBox(
            height: 60,
            child: Row(
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    currentIndex.value = 0;
                  },
                  child: Column(
                    children: [
                      currentIndex.value == 0
                          ? SvgPicture.asset(
                              'assets/svg/home-filled.svg',
                              width: 22,
                              height: 20,
                            )
                          : SvgPicture.asset(
                              'assets/svg/home-2.svg',
                              width: 22,
                              height: 20,
                            ),
                      Text(
                        AppLocalization.of(context).getTranslatedValue("homeTab").toString(),
                        style: TextStyle(
                            fontSize: 11,
                            color: currentIndex.value == 0 ? AppColor.extraDark : null,
                            fontWeight: currentIndex.value == 0 ? FontWeight.w500 : null),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    currentIndex.value = 1;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    // margin: const EdgeInsets.only(right: 80),
                    child: Column(
                      children: [
                        currentIndex.value == 1
                            ? SvgPicture.asset(
                                'assets/svg/jankari-filled.svg',
                                width: 22,
                                height: 20,
                              )
                            : SvgPicture.asset(
                                'assets/svg/jankari.svg',
                                width: 22,
                                height: 20,
                              ),
                        Text(
                          AppLocalization.of(context).getTranslatedValue("jankariTab").toString(),
                          style: TextStyle(
                              fontSize: 11,
                              color: currentIndex.value == 1 ? AppColor.extraDark : null,
                              fontWeight: currentIndex.value == 1 ? FontWeight.w500 : null),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    currentIndex.value = 2;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        currentIndex.value == 2
                            ? SvgPicture.asset(
                                'assets/svg/agPlus_filled.svg',
                                width: 22,
                                height: 19,
                              )
                            : SvgPicture.asset(
                                'assets/svg/agPlus.svg',
                                width: 22,
                                height: 19,
                              ),
                        Text(
                          AppLocalization.of(context).getTranslatedValue("agTab").toString(),
                          style: TextStyle(
                              fontSize: 11,
                              color: currentIndex.value == 2 ? AppColor.extraDark : null,
                              fontWeight: currentIndex.value == 2 ? FontWeight.w500 : null),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    currentIndex.value = 3;
                  },
                  child: Column(
                    children: [
                      Consumer<AuthService>(builder: (context, provider, child) {
                        if (provider.userInfo != null) {
                          final user = provider.userInfo["user"];
                          final profileImage = user['profileImage'];
                          // return Container(
                          //   decoration: BoxDecoration(shape: BoxShape.circle),
                          //   // child: CachedNetworkImage(
                          //   //   imageUrl: profileImage,
                          //   //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                          //   //       Skeleton(
                          //   //     height: 23,
                          //   //     width: 20,
                          //   //     radius: 0,
                          //   //   ),
                          //   //   errorWidget: (context, url, error) => const Icon(Icons.error),
                          //   //   width: 23,
                          //   //   fit: BoxFit.cover,
                          //   //   height: 20,
                          //   // ),
                          //   child: Image.network(profileImage),
                          // );
                          return CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(profileImage), // Profile image
                          );
                          // return ImageIcon(
                          //   NetworkImage(profileImage),
                          //   size: 20,
                          // );
                        }
                        return Container();
                      }),
                      Text(
                        AppLocalization.of(context).getTranslatedValue("profileTab").toString(),
                        style: TextStyle(
                            fontSize: 11,
                            color: currentIndex.value == 3 ? AppColor.extraDark : null,
                            fontWeight: currentIndex.value == 3 ? FontWeight.w500 : null),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabViewModel with ChangeNotifier {
  var screenIndex = 0;
  void onTap(int index) {
    screenIndex = index;
    notifyListeners();
  }

  void disposeValues() {
    screenIndex = 0;
  }
}
