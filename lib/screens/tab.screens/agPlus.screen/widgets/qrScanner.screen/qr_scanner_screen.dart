import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/qrScanner.screen/qr_scanner_view_model.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/utils.dart';

class QRScanner extends HookWidget {
  QRScanner({super.key, required this.currentSelectedPlot});
  Plots currentSelectedPlot;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Consumer<QRScannerViewModel>(builder: (context, provider, child) {
      return currentSelectedPlot.agristick == null
          ? Container(
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
          : Center(
              child: Text(
                  "Agristick ID : ${currentSelectedPlot.agristick.toString()}"),
            );
    });
  }
}
