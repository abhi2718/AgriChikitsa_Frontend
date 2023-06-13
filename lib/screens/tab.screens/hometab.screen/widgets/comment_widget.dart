import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../model/comment.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../hometab_view_model.dart';

class UserComment extends HookWidget {
  final feedId;
  final Function setNumberOfComment;
  const UserComment({
    super.key,
    required this.setNumberOfComment,
    required this.feedId,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final textEditingController = TextEditingController();
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.fetchComments(context, feedId);
      });
    }, []);
    return SizedBox(
      height: dimension["height"]! - 100,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: (dimension["height"]! - 100) * 0.9,
              width: dimension['width']!,
              child: Consumer<HomeTabViewModel>(
                builder: (context, provider, child) {
                  return provider.commentLoading
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 28, right: 32, top: 16),
                          child: ListView.builder(
                              itemCount: provider.commentsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Skeleton(
                                        height: 40,
                                        width: 40,
                                        radius: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Skeleton(height: 10, width: 140),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Skeleton(height: 10, width: 80),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                  height: (dimension["height"]! - 100) * 0.9,
                                  child: ListView.builder(
                                    itemCount: provider.commentsList.length,
                                    itemBuilder: (context, index) {
                                      final comment =
                                          provider.commentsList[index];
                                      return Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                      comment.user.profileImage,
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              SizedBox(
                                                width: dimension['width']! - 98,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    BaseText(
                                                      title: comment.user.name,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    BaseText(
                                                      title: comment.comment,
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                },
              ),
            ),
            Container(
              color: AppColor.lightColor,
              height: (dimension["height"]! - 100) * 0.1,
              child: SizedBox(
                height: 30,
                child: InkWell(
                  onTap: () {
                    Utils.model(
                      context,
                      Container(
                        height: 500,
                        child: Column(
                          children: [
                            TextField(
                              controller: textEditingController,
                              autofocus: true,
                            ),
                            Consumer<HomeTabViewModel>(
                                builder: (context, provider, child) {
                              return ElevatedButton(
                                onPressed: () {
                                  useViewModel.addComment(
                                    context,
                                    feedId,
                                    textEditingController.text,
                                    User.fromJson(authService.userInfo["user"]),
                                  );
                                  setNumberOfComment(
                                      provider.commentsList.length);
                                  Navigator.pop(context);
                                },
                                child: const Text("Submit"),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: dimension['width'],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffd9d9d9),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: BaseText(
                                title: 'Add a  comment',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
