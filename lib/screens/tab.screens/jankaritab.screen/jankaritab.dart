import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/mandiPrices.screen/mandi_prices.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/jankari_card.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/trending_crop_card.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../widgets/skeleton/skeleton.dart';
import '../../../widgets/text.widgets/text.dart';
import '../hometab.screen/hometab_view_model.dart';
import '../hometab.screen/widgets/pdfScree.dart';

class JankariHomeTab extends HookWidget {
  const JankariHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<JankariViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: true);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: true);
    final district = authService.userInfo["user"]["district_en"];
    final homeUseViewModel =
        useMemoized(() => Provider.of<HomeTabViewModel>(context, listen: false));
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (useViewModel.jankaricardList.isEmpty) {
          useViewModel.getJankariCategory(context);
          useViewModel.fetchTrendingCrops(context);
        }
      });
    }, []);
    final url =
        "https://mausam.imd.gov.in/imd_latest/contents/agromet/agromet-data/district/current/local-pdf/$district.pdf";
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: SafeArea(
        child: SizedBox(
          width: dimension['width'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Consumer<HomeTabViewModel>(builder: (context, provider, child) {
                      return InkWell(
                        onTap: provider.weatherPDFloader
                            ? () {}
                            : () async {
                                await homeUseViewModel.openWeatherPDF(context, url).then((value) {
                                  Utils.model(
                                      context,
                                      PDFScreen(
                                        path: value[0],
                                        filename: value[1],
                                      ));
                                });
                              },
                        child: Container(
                          height: dimension['height']! * 0.17,
                          width: dimension['width']! * 0.45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 0.1),
                              gradient: const LinearGradient(
                                  colors: [Color(0xffE5FFAF), Color.fromARGB(255, 238, 247, 219)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0, 0.8]),
                              boxShadow: const [
                                BoxShadow(offset: Offset(1, 1), color: Colors.grey)
                              ]),
                          child: provider.weatherPDFloader
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.extraDark,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      'assets/images/cloudy1.png',
                                      height: (dimension['height']! * 0.17) * 0.5,
                                    ),
                                    BaseText(
                                      title: AppLocalization.of(context)
                                          .getTranslatedValue("checkWeather")
                                          .toString(),
                                      style: GoogleFonts.inter(
                                          fontSize: 14, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                        ),
                      );
                    }),
                    InkWell(
                      onTap: () => Utils.model(context, const MandiPricesScreen()),
                      child: Container(
                        height: dimension['height']! * 0.17,
                        width: dimension['width']! * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 0.1),
                            gradient: const LinearGradient(
                                colors: [Color(0xff8EFF71), Color.fromARGB(255, 202, 244, 191)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0, 0.8]),
                            boxShadow: const [BoxShadow(offset: Offset(1, 1), color: Colors.grey)]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/images/rupee1.png',
                              height: (dimension['height']! * 0.17) * 0.5,
                            ),
                            BaseText(
                              title: AppLocalization.of(context)
                                  .getTranslatedValue("checkPrices")
                                  .toString(),
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BaseText(
                      title: AppLocalization.of(context)
                          .getTranslatedValue("trendingCropsTitle")
                          .toString(),
                      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    InkWell(
                      onTap: () => useViewModel.fetchTrendingCrops(context),
                      child: const SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(Icons.refresh),
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<JankariViewModel>(
                  builder: (context, provider, child) {
                    return provider.loading
                        ? SizedBox(
                            height: dimension['height']! * 0.22,
                            width: dimension['width'],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Skeleton(
                                    height: dimension['height']! * 0.22,
                                    width: dimension['width']! * 0.28,
                                    radius: 10,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Skeleton(
                                    height: dimension['height']! * 0.22,
                                    width: dimension['width']! * 0.28,
                                    radius: 10,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Skeleton(
                                    height: dimension['height']! * 0.22,
                                    width: dimension['width']! * 0.28,
                                    radius: 10,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                ...provider.trendingCropsList.map((crop) {
                                  return TrendingCropCard(
                                      dimension: dimension,
                                      title: profileViewModel.locale["language"] == "en"
                                          ? crop['name']
                                          : crop['name_hi'],
                                      url: crop['image'],
                                      onTap: () {
                                        provider.updateTapCount(context, crop['_id']);
                                        Utils.model(
                                            context,
                                            ShortsPlayer(
                                              videoUrl: crop['shortsUrl'],
                                              aspectRatio: 9 / 16,
                                            ));
                                      });
                                }).toList(),
                              ],
                            ),
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                child: BaseText(
                  title: AppLocalization.of(context).getTranslatedValue("otherInfo").toString(),
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<JankariViewModel>(builder: (context, provider, child) {
                return provider.loading
                    ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: dimension['height'],
                          width: dimension['width'],
                          child: ListView.builder(
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Skeleton(
                                  height: dimension['height']! * 0.16,
                                  width: dimension['width']!,
                                  radius: 8,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          height: dimension['height'],
                          width: dimension['width'],
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...provider.jankaricardList.map((e) {
                                  return JankariCard(
                                    jankari: e,
                                    profileViewModel: profileViewModel,
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
