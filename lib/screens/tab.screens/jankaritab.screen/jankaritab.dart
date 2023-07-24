import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/jankari_card.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../../widgets/skeleton/skeleton.dart';
import '../hometab.screen/hometab_view_model.dart';
import '../hometab.screen/widgets/pdfScree.dart';

class JankariHomeTab extends HookWidget {
  const JankariHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
    final homeUseViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (useViewModel.jankaricardList.isEmpty) {
          useViewModel.getJankariCategory(context);
        }
      });
    }, []);

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: dimension['height'],
          width: dimension['width'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: dimension['height']! * 0.20,
                width: dimension['width'],
                color: AppColor.notificationBgColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        const url =
                            "https://mausam.imd.gov.in/imd_latest/contents/agromet/agromet-data/district/current/local-pdf/Amethi.pdf";
                        final data =
                            await homeUseViewModel.openWeatherPDF(context, url);
                        Utils.model(
                            context,
                            PDFScreen(
                              path: data[0],
                              filename: data[1],
                            ));
                      },
                      child: Container(
                        height: dimension['height']! * 0.15,
                        width: dimension['width']! * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColor.darkColor)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Remix.cloud_windy_line),
                            Text(
                              "Check Weather",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: dimension['height']! * 0.15,
                      width: dimension['width']! * 0.45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.darkColor)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.currency_rupee),
                          Text(
                            "Check Prices",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // const Divider(),
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 12, top: 6),
                child: Text(
                  "Other Info",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<JankariViewModel>(builder: (context, provider, child) {
                return provider.loading
                    // return true
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
                                  return JankariCard(jankari: e);
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
