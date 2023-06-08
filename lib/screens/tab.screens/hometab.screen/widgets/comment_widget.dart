import 'package:agriChikitsa/main.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

class UserComment extends StatelessWidget {
  final user;
  const UserComment({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    return SizedBox(
      height: dimension["height"]! - 100,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: (dimension["height"]! - 100) * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  user['profileImage'],
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BaseText(
                                  title: user['name'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const BaseText(
                                  title:
                                      'Agrichiktsa is best solution for test text the agriculture needs Agrichiktsa is best solution for the agriculture needs Agrichiktsa is best solution for the agriculture needs',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )],
                ),
              ),
            ),
            Container(
              color: AppColor.lightColor,
              height: (dimension["height"]! - 100) * 0.1,
              child: SizedBox(
                height: 30,
                child: InkWell(
                onTap: () {
                  Utils.model(context, Container(
                    height: 500,
                    child: const TextField(
                      autofocus: true,
                    ),
                  ),);
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
