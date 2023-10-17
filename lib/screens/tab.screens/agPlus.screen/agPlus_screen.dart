import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/createPlot.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/helper/noPlotScreen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agristick.screen/agristick_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/weather.screen/weather_screen.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../../widgets/skeleton/skeleton.dart';
import 'agPlus_view_model.dart';

class AGPlus extends HookWidget {
  const AGPlus({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      if (useViewModel.userPlotList.isEmpty) {
        useViewModel.getFields(context);
      }
    }, []);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: SafeArea(child: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
        return provider.getFieldLoader
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : provider.userPlotList.isEmpty
                ? InkWell(
                    onTap: () {
                      Utils.model(context, CreatePlot());
                    },
                    child: NoPlotScreen(),
                  )
                : SizedBox(
                    child: Column(
                      children: [
                        Container(
                          height: dimension["height"]! * 0.30,
                          width: dimension["width"],
                          color: AppColor.whiteColor,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Utils.model(context, CreatePlot());
                                  },
                                  child: Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      height: dimension["height"]! * 0.22,
                                      width: dimension["width"]! * 0.35,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://images.unsplash.com/photo-1559884743-74a57598c6c7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1776&q=80",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Skeleton(
                                                height: dimension["height"]! * 0.22,
                                                width: dimension["width"]! * 0.35,
                                                radius: 10,
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  const Icon(Icons.error),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          const Center(
                                            child: Icon(
                                              Icons.control_point,
                                              size: 34,
                                              color: AppColor.whiteColor,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                ...useViewModel.userPlotList.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      useViewModel.setSelectedField(e);
                                    },
                                    child: Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      height: dimension["height"]! * 0.22,
                                      width: dimension["width"]! * 0.35,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: e.cropImage,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Skeleton(
                                                height: dimension["height"]! * 0.22,
                                                width: dimension["width"]! * 0.35,
                                                radius: 10,
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  const Icon(Icons.error),
                                            ),
                                          ),
                                          e.isSelected
                                              ? Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.4),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          e.isSelected
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    size: 34,
                                                    color: AppColor.whiteColor,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => provider.setSelectedTab(0),
                              child: Container(
                                height: dimension['height']! * 0.10,
                                width: dimension['width']! * 0.5,
                                color: provider.currentSelectTab == 0
                                    ? AppColor.extraDark
                                    : AppColor.unSelectedTabColor,
                                child: Center(
                                  child: BaseText(
                                      title: useViewModel.selectedPlot.fieldName,
                                      style: const TextStyle(fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => provider.setSelectedTab(1),
                              child: Container(
                                height: dimension['height']! * 0.10,
                                width: dimension['width']! * 0.5,
                                color: provider.currentSelectTab == 1
                                    ? AppColor.extraDark
                                    : AppColor.unSelectedTabColor,
                                child: Center(
                                  child: BaseText(
                                      title: AppLocalizations.of(context)!.agristickhi,
                                      style: const TextStyle(fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: provider.currentSelectTab == 0
                                ? WeatherScreen(currentSelectedPlot: provider.selectedPlot)
                                : AgriStickScreen(
                                    currentSelectedPlot: provider.selectedPlot,
                                    agPlusViewModel: useViewModel,
                                  )),
                      ],
                    ),
                  );
      }))),
    );
  }
}
