import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agristick.screen/agristick_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agristick.screen/widgets/date_picker.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agristick.screen/widgets/graph.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/utils.dart';

class AgriStickScreen extends HookWidget {
  AgriStickScreen(
      {super.key,
      required this.currentSelectedPlot,
      required this.agPlusViewModel});
  Plots currentSelectedPlot;
  AGPlusViewModel agPlusViewModel;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        Provider.of<AgristickViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.reinitialize();
    }, [agPlusViewModel.selectedPlot]);
    return Consumer<AgristickViewModel>(builder: (context, provider, child) {
      return currentSelectedPlot.agristick == null
          ? SizedBox(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      title: "Scan QR",
                      onPress: () {
                        provider.scanQRCode(context, currentSelectedPlot);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(provider.barCodeResult),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Center(
                  child: Text(
                      "Agristick ID : ${currentSelectedPlot.agristick['_id'].toString()}"),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    width: dimension['width'],
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(14)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DatePicker(),
                          SoilHealthChart(
                            useViewModel: provider,
                            selectedField: currentSelectedPlot,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
    });
  }
}
