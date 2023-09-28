import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../model/plots.dart';
import '../../../../../repository/AG+.repo/agPlus_repository.dart';
import '../../../../../utils/utils.dart';

class AgristickViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  List<dynamic> graphData = [];
  List<FlSpot> leafWetnessData = [];
  List<FlSpot> soilMoistureData = [];
  String barCodeResult = "";
  DateTime selectedDate = DateTime.now();
  bool showGraph = false;
  void reinitialize() {
    graphData = [];
    leafWetnessData = [];
    soilMoistureData = [];
    barCodeResult = "";
    selectedDate = DateTime.now();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate = picked;
    }
    notifyListeners();
  }

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

  void getGraphData(BuildContext context, Plots currentField) async {
    showGraph = false;
    try {
      soilMoistureData = [];
      leafWetnessData = [];
      final data = await _agPlusRepository.getGraphData(
          currentField.agristick['_id'],
          selectedDate.toLocal().toString().split(' ')[0]);
      graphData = data['averageFieldData'];
      setFlData();
      showGraph = true;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void setFlData() {
    for (int i = 0; i < graphData.length; i++) {
      final leafWetness =
          double.parse(graphData[i]["averageLeafWetness"].replaceAll("%", ""));
      final soilMoisture =
          double.parse(graphData[i]["averageSoilMoisture"].replaceAll("%", ""));
      leafWetnessData.add(FlSpot(i.toDouble(), leafWetness));
      soilMoistureData.add(FlSpot(i.toDouble(), soilMoisture));
    }
  }
}
