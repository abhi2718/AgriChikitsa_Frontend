import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/jankari_card.dart';
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
                    padding:
                        const EdgeInsets.only(top: 33, left: 16, right: 16),
                    height: dimension['height'],
                    width: dimension['width'],
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Skeleton(
                            height: dimension['height']! * 0.16,
                            width: dimension['width']!,
                            radius: 8,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(left: 12, top: 32, right: 12),
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
