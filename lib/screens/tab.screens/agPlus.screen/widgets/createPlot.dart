import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

class CreatePlot extends HookWidget {
  const CreatePlot({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.resetLoader();
    }, []);
    Future<bool> _onWillPop() async {
      if (useViewModel.fieldImageLoader) {
        return false;
      }
      Navigator.pop(context);
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: AppColor.notificationBgColor,
          body: Consumer<AGPlusViewModel>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/animation_lm8y2fde.json',
                          height: dimension['height']! * 0.30,
                          width: dimension['width']! * 0.50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BaseText(
                            title: AppLocalizations.of(context)!.uploadFieldImagehi,
                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        CustomElevatedButton(
                            title: AppLocalizations.of(context)!.openCamerahi,
                            onPress: () => useViewModel.uploadImage(context))
                      ],
                    ),
                  ),
                  if (provider.fieldImageLoader)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColor.whiteColor),
                      ),
                    ),
                ],
              );
            },
          )),
    );
  }
}
