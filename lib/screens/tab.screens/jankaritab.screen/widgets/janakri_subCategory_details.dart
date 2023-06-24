import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../utils/utils.dart';
import '../jankari_view_model.dart';
import 'jankari_subCategory_post.dart';

class JankariSubCategoryPost extends HookWidget {
  final String subCategoryTitle;
  const JankariSubCategoryPost({super.key, required this.subCategoryTitle});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel =
        useMemoized(() => Provider.of<JankariViewModel>(context, listen: true));
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.getJankariSubCategoryPost(context);
      });
    }, []);
    return SizedBox(
      height: dimension['height']! - 100,
      width: dimension['width'],
      child: Padding(
        padding: const EdgeInsets.only(top: 22, left: 29, right: 29),
        child: Column(
          children: [
            SizedBox(
              width: dimension['width'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back)),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        child: const Icon(
                          Remix.close_circle_line,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            useViewModel.jankariSubcategoryPostList.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: Center(
                      child:
                          BaseText(title: "No Posts Yet", style: TextStyle()),
                    ),
                  )
                : Consumer<JankariViewModel>(
                    builder: (context, provider, child) {
                    return InkWell(
                      onTap: () {
                        provider.changeActiveButtonState(
                            !provider.showActiveButton);
                      },
                      child: Stack(
                        children: [
                          JankariPost(
                            subCategoryTitle: subCategoryTitle,
                            index: provider.currentPostIndex,
                          ),
                          if (provider.currentPostIndex != 0 &&
                              provider.showActiveButton)
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: InkWell(
                                  onTap: () => provider.updateCurrentPostIndex(
                                      provider.currentPostIndex - 1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppColor.whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.darkBlackColor
                                              .withOpacity(0.4),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                      color: AppColor.iconColor,
                                    ),
                                  ),
                                )),
                          if (provider.currentPostIndex !=
                                  provider.jankariSubcategoryPostList.length -
                                      1 &&
                              provider.showActiveButton)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () =>
                                    useViewModel.updateCurrentPostIndex(
                                        provider.currentPostIndex + 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: AppColor.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.darkBlackColor
                                            .withOpacity(0.4),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  height: 40,
                                  width: 40,
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    size: 30,
                                    color: AppColor.iconColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  })
          ],
        ),
      ),
    );
  }
}
