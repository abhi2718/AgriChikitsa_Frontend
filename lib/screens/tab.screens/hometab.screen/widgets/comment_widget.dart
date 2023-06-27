import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

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
      height: dimension["height"]! - 60,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Remix.close_circle_line,
              ),
            ),
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
                              itemCount: 10,
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
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
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
            SizedBox(
              height: (dimension["height"]! - 60) * 0.09,
              child: InkWell(
                onTap: () {
                  Utils.model(
                      context,
                      WillPopScope(
                        onWillPop: () async {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          return false;
                        },
                        child: SizedBox(
                          height: dimension['height']! * 0.60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Remix.close_circle_line,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Consumer<AuthService>(
                                      builder: (context, provider, child) {
                                    if (provider.userInfo != null) {
                                      final user = provider.userInfo["user"];
                                      return CircleAvatar(
                                        // backgroundImage: NetworkImage(user["profileImage"]),
                                        child: ClipOval(
                                          child: Image.network(
                                            user['profileImage'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                                  SizedBox(
                                    width: dimension['width']! - 150,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                        hintText: AppLocalizations.of(context)!
                                            .addAComment,
                                        hintStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller: textEditingController,
                                      autofocus: true,
                                    ),
                                  ),
                                  Consumer<HomeTabViewModel>(
                                      builder: (context, provider, child) {
                                    return InkWell(
                                      onTap: () {
                                        useViewModel.addComment(
                                          context,
                                          feedId,
                                          textEditingController.text,
                                          User.fromJson(
                                              authService.userInfo["user"]),
                                        );
                                        setNumberOfComment(
                                            provider.commentsList.length);
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        "assets/icons/send_icon.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
                },
                child: SizedBox(
                  width: dimension['width'],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 16),
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xffd9d9d9),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          title: AppLocalizations.of(context)!.addAComment,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
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
