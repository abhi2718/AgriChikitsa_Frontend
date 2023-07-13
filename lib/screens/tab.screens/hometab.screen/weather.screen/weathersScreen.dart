import 'package:agriChikitsa/screens/tab.screens/hometab.screen/weather.screen/weatherScreenViewModel.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../widgets/text.widgets/text.dart';

class WeatherScreen extends HookWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<WeatherViewModel>(context, listen: false));
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     const SystemUiOverlayStyle(statusBarColor: AppColor.statusBarColor),
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: const Icon(Icons.arrow_back)),
        title: const BaseText(
          // title: AppLocalizations.of(context)!.createPosthi,
          title: "Birkuniya, M.P",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          height: dimension['height']! * 0.5,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff000000), Color(0xff105713)])),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: dimension['height']! * 0.35,
            width: dimension['width']!,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff000000), Color(0xff105713)])),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const BaseText(
                    title: "Sunday, 20 Desember 2021 - 10.30 PM",
                    style: TextStyle(color: AppColor.whiteColor)),
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/images/cloud.png'),
                const BaseText(
                    title: "18º C",
                    style: TextStyle(color: AppColor.whiteColor, fontSize: 22)),
                const SizedBox(
                  height: 5,
                ),
                const BaseText(
                    title: "Rain Drizzle",
                    style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BaseText(
                        title: "Last update 8.00 PM",
                        style: TextStyle(
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () {
                        //Refresh to be implemented
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: AppColor.whiteColor,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 14),
            height: dimension['height']! * 0.12,
            color: AppColor.statusBarColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: dimension['height']! * 0.07,
                  width: dimension['width']! * 0.27,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 1,
                            spreadRadius: 0.8,
                            offset: Offset(0, 2))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffDCD755)),
                  child: const Center(
                    child: BaseText(
                      title: "Today",
                      style: TextStyle(
                          color: AppColor.darkBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: dimension['height']! * 0.07,
                  width: dimension['width']! * 0.27,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 1,
                            spreadRadius: 0.8,
                            offset: Offset(0, 2))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffD9D9D9)),
                  child: const Center(
                    child: BaseText(
                      title: "Hourly",
                      style: TextStyle(
                          color: AppColor.darkBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: dimension['height']! * 0.07,
                  width: dimension['width']! * 0.27,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 1,
                            spreadRadius: 0.8,
                            offset: Offset(0, 2))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffD9D9D9)),
                  child: const Center(
                    child: BaseText(
                      title: "10 Days",
                      style: TextStyle(
                          color: AppColor.darkBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            height: dimension['height']! * 0.53,
            width: dimension['width']!,
            color: AppColor.notificationBgColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherCard(
                      dimension: dimension,
                      value: '86%',
                      title: 'Visibility',
                      imagePath: 'assets/icons/visibility.png',
                    ),
                    WeatherCard(
                      dimension: dimension,
                      value: '86%',
                      title: 'Visibility',
                      imagePath: 'assets/icons/visibility.png',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherCard(
                      dimension: dimension,
                      value: '86%',
                      title: 'Visibility',
                      imagePath: 'assets/icons/visibility.png',
                    ),
                    WeatherCard(
                      dimension: dimension,
                      value: '86%',
                      title: 'Visibility',
                      imagePath: 'assets/icons/visibility.png',
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard(
      {super.key,
      required this.dimension,
      required this.title,
      required this.value,
      required this.imagePath});

  final dynamic dimension;
  final String title;
  final String value;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: dimension['height']! * 0.10,
      width: dimension['width']! * 0.43,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: const Color(0xffFAFAFA)),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/visibility.png',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  title: value,
                  style: const TextStyle(
                      color: AppColor.darkBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                BaseText(
                  title: title,
                  style: TextStyle(
                      color: Color(0xff494343),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
