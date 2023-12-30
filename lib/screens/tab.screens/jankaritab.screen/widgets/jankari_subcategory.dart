import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/janakri_category_button.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/janakri_subCategory_details.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../jankari_view_model.dart';

class SubCategoryContainer extends HookWidget {
  final ProfileViewModel profileViewModel;
  const SubCategoryContainer({super.key, required this.profileViewModel});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    return SizedBox(
      height: dimension['height']! - 80,
      width: dimension['width'],
      child: Padding(
        padding: const EdgeInsets.only(top: 25.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
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
                          onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                          child: const Icon(
                            Remix.close_circle_line,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BaseText(
                      title: AppLocalization.of(context)
                          .getTranslatedValue("jankariSubcategoryTitle")
                          .toString(),
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer<JankariViewModel>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          height: 30,
                          width: dimension["width"],
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.jankaricardList.length,
                              itemBuilder: (context, index) {
                                return JankariSubCategoryButton(
                                  profileViewModel: profileViewModel,
                                  category: provider.jankaricardList[index],
                                  onTap: () {
                                    provider.setActiveState(
                                      context,
                                      provider.jankaricardList[index],
                                    );
                                  },
                                );
                              }),
                        );
                      },
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
                        ? Container(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 17.5),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: ((dimension['width']! - 10) / 2) / 147,
                              ),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6, right: 6),
                                  child: Skeleton(
                                    height: 100,
                                    width: 150,
                                    radius: 12,
                                  ),
                                );
                              },
                            ),
                          )
                        : provider.jankariSubcategoryList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: Center(
                                  child: BaseText(
                                      title: AppLocalization.of(context)
                                          .getTranslatedValue("noPostYet")
                                          .toString(),
                                      style: const TextStyle(fontSize: 15)),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: GridView.builder(
                                  itemCount: provider.jankariSubcategoryList.length,
                                  padding: const EdgeInsets.only(top: 27),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: ((dimension['width']! - 8) / 2) / 143,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    final subCategory = provider.jankariSubcategoryList[index];
                                    final backgroundImage = subCategory.backgroundImage;
                                    return InkWell(
                                      onTap: () {
                                        provider.updateStats(context, 'subcategory',
                                            provider.jankariSubcategoryList[index].id);
                                        provider.setSelectedSubCategory(
                                            provider.jankariSubcategoryList[index].id);
                                        provider.getJankariSubCategoryPost(context);
                                        Utils.model(
                                            context,
                                            JankariSubCategoryPost(
                                              profileViewModel: profileViewModel,
                                              subCategoryTitle:
                                                  profileViewModel.locale["language"] == "en"
                                                      ? provider.jankariSubcategoryList[index].name
                                                      : provider
                                                          .jankariSubcategoryList[index].hindiName,
                                            ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 6, right: 6),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                imageUrl: backgroundImage,
                                                progressIndicatorBuilder:
                                                    (context, url, downloadProgress) => Skeleton(
                                                  height: 40,
                                                  width: 40,
                                                  radius: 0,
                                                ),
                                                errorWidget: (context, url, error) =>
                                                    const Icon(Icons.error),
                                                width: 40,
                                                fit: BoxFit.fill,
                                                height: 40,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.3),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: subCategory.hindiName.length > 8
                                                    ? Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                        child: BaseText(
                                                          title:
                                                              profileViewModel.locale["language"] ==
                                                                      "en"
                                                                  ? subCategory.name
                                                                  : subCategory.hindiName,
                                                          style: const TextStyle(
                                                              color: AppColor.whiteColor,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                      )
                                                    : BaseText(
                                                        title:
                                                            profileViewModel.locale["language"] ==
                                                                    "en"
                                                                ? subCategory.name
                                                                : subCategory.hindiName,
                                                        style: const TextStyle(
                                                            color: AppColor.whiteColor,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
