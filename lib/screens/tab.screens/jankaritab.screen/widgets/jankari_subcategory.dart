import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/janakri_category_button.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/janakri_subCategory_details.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../jankari_view_model.dart';

class SubCategoryContainer extends HookWidget {
  const SubCategoryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    return SizedBox(
      height: dimension['height']! - 80,
      width: dimension['width'],
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 25.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: dimension['width'],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(
                      height: 10,
                    ),
                    const BaseText(
                      title: "Select your crop",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: dimension["width"],
                            child: Consumer<JankariViewModel>(
                              builder: (context, provider, child) {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        provider.jankariSubcategoryList.length,
                                    itemBuilder: (context, index) {
                                      return JankariSubCategoryButton(
                                        category:
                                            provider.jankaricardList[index],
                                        onTap: () {
                                          Utils.toastMessage(provider
                                              .jankaricardList[index].name);
                                          provider.setActiveState(
                                            context,
                                            provider.jankaricardList[index],
                                          );
                                        },
                                      );
                                    });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dimension['height']! - 180,
                width: dimension['width'],
                child: Consumer<JankariViewModel>(
                  builder: (context, provider, child) {
                    return provider.jankariSubCategoryLoader
                        ? SizedBox(
                            height: 100,
                            width: 150,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: provider.jankaricardList.length,
                              itemBuilder: (context, index) {
                                return const Skeleton(
                                  height: 100,
                                  width: 100,
                                );
                              },
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
                                onTap: () {
                                  provider.setSelectedSubCategory(provider
                                      .jankariSubcategoryList[index].id);
                                  provider.getJankariSubCategoryPost(context);
                                  Utils.model(
                                      context,
                                      JankariSubCategoryPost(
                                        subCategoryTitle: provider
                                            .jankariSubcategoryList[index].name,
                                      ));
                                },
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        BaseText(
                                          title: subCategory.name,
                                          style: const TextStyle(
                                              color: AppColor.whiteColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                        // ParagraphHeadingText(
                                        //   subCategory.name,
                                        //   textAlign: TextAlign.justify,
                                        // )
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
        ),
      ),
    );
  }
}
