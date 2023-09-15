import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/createPlot.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/helper/noPlotScreen.dart';
import 'package:agriChikitsa/widgets/button.widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
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
    return Scaffold(body: SafeArea(
        child: Consumer<AGPlusViewModel>(builder: (context, provider, child) {
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
                        color: Color(0xff1E1E1E),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Utils.model(context, CreatePlot());
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      // image: const DecorationImage(
                                      //     fit: BoxFit.cover,
                                      //     image: NetworkImage(
                                      //         "https://images.unsplash.com/photo-1512233866604-11b9c3d7ec96?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80")),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: dimension["height"]! * 0.22,
                                  width: dimension["width"]! * 0.35,
                                  child: const Center(
                                    child: Icon(
                                      Icons.control_point,
                                      size: 34,
                                    ),
                                  ),
                                ),
                              ),
                              ...useViewModel.userPlotList.map((e) {
                                final plotImage = e.cropImage.split(
                                    'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
                                return InkWell(
                                  onTap: () {
                                    useViewModel.setSelectedField(e);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //     fit: BoxFit.cover,
                                        //     image: NetworkImage(
                                        //         'https://d336izsd4bfvcs.cloudfront.net/$plotImage')
                                        // ),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              'https://d336izsd4bfvcs.cloudfront.net/$plotImage',
                                            ),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: dimension["height"]! * 0.22,
                                    width: dimension["width"]! * 0.35,
                                    child: Stack(
                                      children: [
                                        e.isSelected
                                            ? Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
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
                      Container(
                        height: dimension["height"]! * 0.09,
                        width: dimension["width"]!,
                        color: AppColor.extraDark,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                                height: dimension["height"]! * 0.06,
                                width: dimension["width"]! * 0.30,
                                color: Colors.yellow,
                                fontSize: 16,
                                titleColor: AppColor.darkBlackColor,
                                title: useViewModel.selectedPlot.fieldName),
                            CustomButton(
                                height: dimension["height"]! * 0.06,
                                width: dimension["width"]! * 0.30,
                                color: Colors.yellow,
                                fontSize: 16,
                                titleColor: AppColor.darkBlackColor,
                                title: "Agristick"),
                          ],
                        ),
                      )
                    ],
                  ),
                );
    })));
  }
}
