import 'dart:io';

import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/widgets/post_header.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PostHeader(),
            SizedBox(
              height: 16,
            ),
            Consumer<CreatePostModel>(builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () => provider.pickPostImage(context, authService),
                  child: DottedBorder(
                    color: AppColor.darkColor,
                    strokeWidth: 2,
                    dashPattern: [8, 4],
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: dimension['height']! - 450,
                      width: dimension['width'],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: useViewModel.imagePath.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Remix.add_line),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BaseText(
                                    title: "Upload Image",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : Image.file(
                              File(provider.imagePath),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: useViewModel.editUserformKey,
                child: Column(
                  children: [
                    Consumer<CreatePostModel>(
                      builder: (context, provider, child) => Input(
                        labelText: "Enter Caption",
                        focusNode: useViewModel.nameFocusNode,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        // suffixIcon: useViewModel.suffixIconForName(),
                        // initialValue: "Enter Caption",
                        validator: useViewModel.nameFieldValidator,
                        onSaved: useViewModel.onSavedNameField,
                        onFieldSubmitted: (_) {
                          Utils.fieldFocusChange(
                              context,
                              useViewModel.nameFocusNode,
                              useViewModel.emailFocusNode);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer<CreatePostModel>(
                      builder: (context, provider, child) => Input(
                          labelText: "Select Category",
                          focusNode: useViewModel.emailFocusNode,
                          // suffixIcon: useViewModel.suffixIconForEmail(),
                          keyboardType: TextInputType.emailAddress,
                          // initialValue: user.email ?? "",
                          textInputAction: TextInputAction.done,
                          validator: useViewModel.nameFieldValidator,
                          onSaved: useViewModel.onSavedNameField,
                          onFieldSubmitted: (_) {}
                          // provider.saveForm(context, user, authService),
                          ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Consumer<CreatePostModel>(
                      builder: (context, provider, child) =>
                          CustomElevatedButton(
                              title: "Post",
                              // loading: provider.loading,
                              width: dimension["width"]! - 32,
                              onPress: () {
                                useViewModel.clearImagePath();
                              }
            
                              // provider.saveForm(context, user, authService),
                              ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
