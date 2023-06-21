import 'dart:io';

import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/Input.widgets/input.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../../../../widgets/text.widgets/text.dart';
import './widgets/post_category_button.dart';

class CreatePostScreen extends HookWidget {
  const CreatePostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<CreatePostModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: true);
    useEffect(() {
      useViewModel.fetchFeedsCategory(context);
    }, []);
    void closeKeyboard() {
      useFocusNode().unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: const Icon(Icons.arrow_back)),
        title: const BaseText(
          title: "Create Post",
          style: TextStyle(
              color: AppColor.darkBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: useViewModel.buttonloading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CreatePostModel>(
                        builder: (context, provider, child) {
                      return InkWell(
                        onTap: () =>
                            provider.pickPostImage(context, authService),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: dimension['height']! * 0.45,
                          width: dimension['width'],
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.darkColor, width: 2.0)),
                          child: useViewModel.imagePath.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/gallery.jpg'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const BaseText(
                                          title: "Click Here to Upload Image",
                                          style: TextStyle()),
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
                    TextField(
                      controller: useViewModel.captionController,
                      decoration: const InputDecoration(
                        labelText: "Enter Caption",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        useViewModel.onSavedCaptionField(value);
                      },
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      onSubmitted: (_) => useViewModel.onSavedCaptionField(
                          useViewModel.captionController.text),
                      onEditingComplete: () {
                        useViewModel.handleUserInput(context);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const BaseText(
                        title: "Select Category", style: TextStyle()),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: dimension["width"],
                      child: SizedBox(
                        height: 30,
                        child: Consumer<CreatePostModel>(
                          builder: (context, provider, child) {
                            return provider.categoryLoading
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 100,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Skeleton(
                                          height: 10,
                                          width: 100,
                                          radius: 10,
                                        ),
                                      );
                                    })
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: provider.categoriesList.length,
                                    itemBuilder: (context, index) {
                                      return CategoryButton(
                                        category:
                                            provider.categoriesList[index],
                                        onTap: () {
                                          provider.setActiveState(
                                            context,
                                            provider.categoriesList[index],
                                            provider
                                                .categoriesList[index].isActive,
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
                      builder: (context, provider, child) =>
                          CustomElevatedButton(
                              title: "Update",
                              // loading: provider.loading,
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
