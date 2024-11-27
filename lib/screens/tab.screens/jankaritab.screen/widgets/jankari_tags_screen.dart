import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/janakri_subCategory_details.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class JankariTagsScreen extends StatelessWidget {
  final ProfileViewModel profileViewModel;
  final int index;
  final dynamic subCategory;
  const JankariTagsScreen(
      {super.key, required this.profileViewModel, required this.index, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: BaseText(
                title: profileViewModel.locale["language"] == "en"
                    ? subCategory.name
                    : subCategory.hindiName,
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: dimension['height']! - 160,
              width: dimension['width'],
              child: Consumer<JankariViewModel>(
                builder: (context, provider, child) {
                  print(provider.jankariSubcategoryList[index].tags);
                  return provider.jankariSubCategoryLoader
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(top: 27, bottom: 27),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 6.0,
                              mainAxisSpacing: 6.0,
                              childAspectRatio: ((dimension['width']! - 10) / 2) / 148,
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
                      : provider.jankariSubcategoryList[index].tags.isEmpty
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
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.builder(
                                itemCount: provider.jankariSubcategoryList[index].tags.length,
                                padding: const EdgeInsets.only(bottom: 27),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 6.0,
                                  mainAxisSpacing: 6.0,
                                  childAspectRatio: ((dimension['width']! - 10) / 2) / 148,
                                ),
                                itemBuilder: (BuildContext context, int count) {
                                  final subCategory =
                                      provider.jankariSubcategoryList[index].tags[count];
                                  final backgroundImage = subCategory["image"];
                                  return InkWell(
                                    onTap: () {
                                      provider.getJankariSubCategoryTagsPost(
                                          context,
                                          provider.jankariSubcategoryList[index].tags[count]
                                              ["_id"]);
                                      Utils.model(
                                          context,
                                          JankariSubCategoryPost(
                                            isFromTagsScreen: true,
                                            tagId: provider
                                                .jankariSubcategoryList[index].tags[count]["_id"],
                                            profileViewModel: profileViewModel,
                                            subCategoryTitle: profileViewModel.locale["language"] ==
                                                    "en"
                                                ? provider.jankariSubcategoryList[index].tags[count]
                                                    ["name"]
                                                : provider.jankariSubcategoryList[index].tags[count]
                                                    ["name_hi"],
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
                                            child: subCategory["name_hi"].length > 8
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 20),
                                                    child: BaseText(
                                                      title: profileViewModel.locale["language"] ==
                                                              "en"
                                                          ? subCategory["name"]
                                                          : subCategory["name_hi"],
                                                      style: const TextStyle(
                                                          color: AppColor.whiteColor,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  )
                                                : BaseText(
                                                    title:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? subCategory["name"]
                                                            : subCategory["name_hi"],
                                                    style: const TextStyle(
                                                        color: AppColor.whiteColor,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600),
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
    );
  }
}
