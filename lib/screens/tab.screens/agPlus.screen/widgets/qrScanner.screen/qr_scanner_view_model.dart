import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../model/plots.dart';
import '../../../../../repository/AG+.repo/agPlus_repository.dart';
import '../../../../../utils/utils.dart';

class QRScannerViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  String barCodeResult = "";
  Future<void> scanQRCode(BuildContext context, Plots currentField) async {
    String barCodeScanRes;
    try {
      barCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.QR);
      barCodeResult = barCodeScanRes == "-1" ? "Scan Failed" : barCodeScanRes;
      if (barCodeScanRes == "-1") {
        barCodeResult = "Scan Failed";
      } else {
        barCodeResult = barCodeScanRes;
        activateAgristick(context, currentField);
      }
      notifyListeners();
    } on PlatformException {
      barCodeScanRes = "Failed to scan barcode";
    }
    // if (!mounted) return;
  }

  void activateAgristick(BuildContext context, Plots currentField) async {
    try {
      final data = await _agPlusRepository.activateAgristick(
          barCodeResult, currentField.id);
      if (data["agristick"]["status"] == "Activated") {
        currentField.agristick = data["agristick"]["_id"];
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }
}
