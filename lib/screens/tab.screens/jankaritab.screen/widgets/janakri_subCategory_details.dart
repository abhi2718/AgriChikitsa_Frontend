import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../utils/utils.dart';
import '../jankari_view_model.dart';
import 'jankari_subCategory_post.dart';

class JankariSubCategoryPost extends HookWidget {
  final String subCategoryTitle;
  const JankariSubCategoryPost({super.key, required this.subCategoryTitle});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
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
                          child: const Icon(Icons.cancel)),
                    ],
                  ),
                ],
              ),
            ),
            Consumer<JankariViewModel>(builder: (context, provider, child) {
              return Stack(
                children: [
                  JankariPost(
                    subCategoryTitle: subCategoryTitle,
                    index: provider.currentPostIndex,
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: InkWell(
                        onTap: () => provider.updateCurrentPostIndex(
                            provider.currentPostIndex - 1),
                        child: const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 40,
                            color: AppColor.iconColor,
                          )),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => useViewModel.updateCurrentPostIndex(
                            provider.currentPostIndex + 1),
                        child: const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 40,
                            color: AppColor.iconColor,
                          )),
                        ),
                      )),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
