import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/select_crop_model.dart';
import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../agPlus_view_model.dart';

class CropItem extends StatelessWidget {
  CropItem({
    super.key,
    required this.crop,
  });
  SelectCrop crop;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    return Consumer<AGPlusViewModel>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () => useViewModel.setSelectedCrop(context, crop),
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  height: dimension["height"]! * 0.125,
                  width: dimension["width"]! * 0.235,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54, spreadRadius: 1, blurRadius: 8)
                    ],
                    image: const DecorationImage(
                        // image: NetworkImage(crop.backgroundImage),
                        image: NetworkImage(
                            "https://images.pexels.com/photos/46164/field-of-rapeseeds-oilseed-rape-blutenmeer-yellow-46164.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Stack(
                    children: crop.isSelected
                        ? [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                            const Center(
                              child: Icon(
                                Icons.done,
                                size: 36,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ]
                        : [],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(crop.name)
              ],
            ),
          ),
        );
      },
    );
  }
}
