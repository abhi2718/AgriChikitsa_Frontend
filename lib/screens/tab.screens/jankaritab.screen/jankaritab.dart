import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/jankari_card.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../widgets/skeleton/skeleton.dart';

class JankariHomeTab extends HookWidget {
  const JankariHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.getJankariCategory(context);
      });
    }, []);

    return Scaffold(
      body: SizedBox(
        height: dimension['height'],
        width: dimension['width'],
        child: SingleChildScrollView(
          child:
              Consumer<JankariViewModel>(builder: (context, provider, child) {
            return provider.loading
                ? Container(
                    padding: const EdgeInsets.only(
                        top: 32, left: 16, right: 16, bottom: 16),
                    // margin: EdgeInsets.only(bottom: 10, top: 16),
                    height: dimension['height'],
                    width: dimension['width'],
                    child: ListView.builder(
                      itemCount: provider.jankaricardList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Row(
                            children: [
                              const Skeleton(
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Skeleton(
                                      height: 20,
                                      width: dimension['width']! - 130),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Skeleton(
                                      height: 10,
                                      width: dimension['width']! - 150),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    width: dimension['width'],
                    height: dimension['height'],
                    child: ListView.builder(
                      itemCount: provider.jankaricardList.length,
                      itemBuilder: (context, index) {
                        return JankariCard(
                          jankari: provider.jankaricardList[index],
                        );
                      },
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
