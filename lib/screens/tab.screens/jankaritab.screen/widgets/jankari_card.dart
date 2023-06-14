import 'package:agriChikitsa/model/jankari_card_modal.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../jankari_view_model.dart';
import './jankari_subcategory.dart';

class JankariCard extends HookWidget {
  final JankariCategoryModal jankari;
  const JankariCard({
    super.key,
    required this.jankari,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));

    return InkWell(
      onTap: () {
        useViewModel.setCategory(jankari.id);
        useViewModel.getJankariSubCategory(context, jankari.id);
        Utils.model(context, const SubCategoryContainer());
      },
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Card(
          child: Container(
            height: 110,
            width: dimension['width']! - 20,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(jankari.backgroundImage),
                fit: BoxFit.fill,
              ),
              // borderRadius: const BorderRadius.all(
              //   Radius.circular(12),
              // ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 2,
                ),
                Image(
                  height: 50,
                  width: 50,
                  image: NetworkImage(jankari.icon),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: dimension["width"]! - 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseText(
                        title: jankari.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.whiteColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BaseText(
                        title: jankari.description,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
