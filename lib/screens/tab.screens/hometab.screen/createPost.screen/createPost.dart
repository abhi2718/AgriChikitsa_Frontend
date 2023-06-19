import 'dart:io';

import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/Input.widgets/input.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: Icon(Icons.arrow_back)),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaseText(
                title: "Create Post",
                style: TextStyle(
                    color: AppColor.darkBlackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              Consumer<CreatePostModel>(builder: (context, provider, child) {
                return InkWell(
                  onTap: () => provider.pickPostImage(context, authService),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: dimension['height']! * 0.45,
                    width: dimension['width'],
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.darkColor, width: 2.0)),
                    child: useViewModel.imagePath.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/gallery.jpg'),
                                const SizedBox(
                                  height: 10,
                                ),
                                BaseText(
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
              Form(
                key: useViewModel.editUserformKey,
                child: Column(
                  children: [
                    Consumer<CreatePostModel>(
                      builder: (context, provider, child) => Input(
                        labelText: "Enter Caption",
                        focusNode: useViewModel.captionFocusNode,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        // suffixIcon: useViewModel.suffixIconForName(),
                        // initialValue: "Enter Caption",
                        validator: useViewModel.nameFieldValidator,
                        onSaved: useViewModel.onSavedCaptionField,
                        onFieldSubmitted: (value) {
                          useViewModel.onSavedCaptionField(value);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer<CreatePostModel>(
                        builder: (context, provider, child) {
                      return Container(
                        height: 40,
                        width: dimension['width'],
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.darkColor),
                        ),
                        child: Center(
                          child: Builder(builder: (BuildContext context) {
                            return DropdownButton<String>(
                              value: provider.selectedKey,
                              onChanged: (String? key) {
                                provider.updateSelectedOption(key!);
                              },
                              items: provider.dropdownOptions.entries
                                  .map<DropdownMenuItem<String>>(
                                (MapEntry<String, String> entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                },
                              ).toList(),
                            );
                          }),
                        ),
                      );
                    }),
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
                                useViewModel.createPost(
                                  context,
                                );
                                useViewModel.clearImagePath();
                              }
                              // provider.saveForm(context, user, authService),
                              ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
