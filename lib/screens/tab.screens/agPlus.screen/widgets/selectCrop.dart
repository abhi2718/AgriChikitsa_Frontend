import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/plotDetails.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../agPlus_view_model.dart';
import 'helper/cropItem.dart';

class CropSelection extends HookWidget {
  const CropSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.getCropList(context);
    }, []);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BaseText(
                  title: "Select Your Crop", style: TextStyle(fontSize: 26)),
              Consumer<AGPlusViewModel>(builder: (context, provider, child) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  height: dimension["height"]! * 0.90,
                  child: provider.addFieldLoader
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                          itemCount: useViewModel.cropList.length,
                          itemBuilder: (context, index) {
                            return CropItem(
                              crop: useViewModel.cropList[index],
                            );
                          }),
                );
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          if (useViewModel.selectedCrop.isEmpty) {
            Utils.toastMessage("Please Select your crop!");
          } else {
            Utils.model(context, const PlotDetails());
          }
        },
        child: const Icon(
          Icons.arrow_forward_ios,
          color: AppColor.extraDark,
        ),
      ),
    );
  }
}
