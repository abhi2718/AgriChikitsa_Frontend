import 'dart:io';

import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import './widgets/post_category_button.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../../../../widgets/text.widgets/text.dart';

class CreatePostScreen extends HookWidget {
  const CreatePostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<CreatePostModel>(context, listen: false));
    final hometabViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: true);
    useEffect(() {
      useViewModel.fetchFeedsCategory(context, hometabViewModel);
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: const Icon(Icons.arrow_back)),
        title: BaseText(
          title: AppLocalizations.of(context)!.createPosthi,
          style: const TextStyle(
              color: AppColor.darkBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<CreatePostModel>(builder: (context, provider, child) {
                return InkWell(
                  onTap: () => provider.pickPostImage(context, authService),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: dimension['width']! - 16,
                    width: dimension['width']! - 16,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.darkColor, width: 2.0)),
                    child: useViewModel.imagePath.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/gallery.png',
                                  width: 26,
                                  height: 26,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                BaseText(
                                    title: AppLocalizations.of(context)!
                                        .clickImageUploadhi,
                                    style: const TextStyle()),
                              ],
                            ),
                          )
                        : Image.file(
                            File(provider.imagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLength: 225,
                controller: useViewModel.captionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterCaptionhi,
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.darkColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  useViewModel.onSavedCaptionField(value);
                },
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onSubmitted: (_) {
                  useViewModel
                      .onSavedCaptionField(useViewModel.captionController.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {
                  useViewModel.handleUserInput(context);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BaseText(
                  title: AppLocalizations.of(context)!.selectCategoeyhi,
                  style: const TextStyle()),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: dimension["width"],
                child: SizedBox(
                  height: 30,
                  child: Consumer<CreatePostModel>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.categoriesList.length,
                          itemBuilder: (context, index) {
                            return CategoryButton(
                              category: provider.categoriesList[index],
                              onTap: () {
                                provider.setActiveState(
                                  context,
                                  provider.categoriesList[index],
                                  provider.categoriesList[index].isActive,
                                );
                              },
                            );
                          });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Consumer<CreatePostModel>(
                builder: (context, provider, child) => CustomElevatedButton(
                    title: AppLocalizations.of(context)!.updatehi,
                    loading: provider.buttonloading,
                    width: dimension["width"]! - 32,
                    onPress: () {
                      useViewModel.createPost(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
