import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../utils/utils.dart';
import '../jankari_view_model.dart';

class SubCategoryContainer extends HookWidget {
  const SubCategoryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final List<String> items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
      'Item 6',
      'Item 4',
      'Item 5',
      'Item 6',
    ];
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
    return SizedBox(
      height: dimension['height']! - 80,
      width: dimension['width'],
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: dimension['width'],
            child: Container(),
          ),
          SizedBox(
            height: dimension['height']! - 180,
            width: dimension['width'],
            child: Consumer<JankariViewModel>(
              builder: (context, provider, child) {
                return provider.jankariSubCategoryLoader
                    ? SizedBox(
                        height: dimension['height']! - 180,
                        width: dimension['width'],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : GridView.builder(
                        itemCount: provider.jankariSubcategoryList.length,
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final subCategory =
                              provider.jankariSubcategoryList[index];
                          return InkWell(
                            onTap: () {},
                            child: SizedBox(
                              height: 100,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        subCategory.backgroundImage),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ParagraphHeadingText(
                                  subCategory.name,
                                  textAlign: TextAlign.justify,
                                )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
