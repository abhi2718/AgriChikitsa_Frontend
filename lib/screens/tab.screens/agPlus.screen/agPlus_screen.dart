import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/createPlot.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/helper/noPlotScreen.dart';
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
      useViewModel.getFields(context);
    }, []);
    return Scaffold(
      body: SafeArea(
        // child: useViewModel.userPlotList.isEmpty
        child: false
            ? InkWell(
                onTap: () {
                  Utils.model(context, CreatePlot());
                },
                child: Container(
                  child: NoPlotScreen(),
                ),
              )
            : Container(
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
                            ...useViewModel.userPlotList.map((e) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://images.unsplash.com/photo-1512233866604-11b9c3d7ec96?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80")),
                                    borderRadius: BorderRadius.circular(10)),
                                height: dimension["height"]! * 0.22,
                                width: dimension["width"]! * 0.35,
                                child: true
                                    ? Center(
                                        child: Icon(
                                          Icons.control_point,
                                          size: 34,
                                        ),
                                      )
                                    : Container(),
                              );
                            }).toList(),
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
                            )
                            // Container(
                            //   height: dimension["height"]! * 0.25,
                            //   width: dimension["width"],
                            //   child: ListView.builder(
                            //       scrollDirection: Axis.horizontal,
                            //       itemCount: 3,
                            //       itemBuilder: (context, index) {
                            // return Container(
                            //   margin: EdgeInsets.symmetric(
                            //       vertical: 20, horizontal: 10),
                            //   decoration: BoxDecoration(
                            //       image: const DecorationImage(
                            //           fit: BoxFit.cover,
                            //           image: NetworkImage(
                            //               "https://images.unsplash.com/photo-1512233866604-11b9c3d7ec96?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80")),
                            //       borderRadius:
                            //           BorderRadius.circular(10)),
                            //   height: dimension["height"]! * 0.22,
                            //   width: dimension["width"]! * 0.35,
                            //   child: Center(
                            //     child: Icon(
                            //       Icons.control_point,
                            //       size: 34,
                            //     ),
                            //   ),
                            // );
                            //       }),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: dimension["height"]! * 0.09,
                      width: dimension["width"]!,
                      color: AppColor.extraDark,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
