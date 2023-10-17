import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agristick.screen/widgets/activateAgristickStatusScreen.dart';
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
  double maxY = 0;
  double maxLeafWetnessY = 0;
  DateTime selectedDate = DateTime.now();
  bool showGraph = false;
  bool scanBarCodeLoader = false;
  late bool agristickStatus;

  void reinitialize() {
    graphData = [];
    maxY = 0;
    maxLeafWetnessY = 0;
    leafWetnessData = [];
    soilMoistureData = [];
    barCodeResult = "";
    selectedDate = DateTime.now();
  }

  void setBarCodeLoader(value) {
    scanBarCodeLoader = value;
    notifyListeners();
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
      barCodeResult = barCodeScanRes == "-1"
          ? AppLocalizations.of(context)!.scanFailhi
          : barCodeScanRes;
      if (barCodeScanRes == "-1") {
        barCodeResult = AppLocalizations.of(context)!.scanFailhi;
      } else {
        setBarCodeLoader(true);
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
        agristickStatus = true;
        Utils.model(context, AgriStickStatusScreen());
      } else {
        barCodeResult = "अमान्य एग्रीस्टिक प्रदान की गई";
        agristickStatus = false;
        Utils.model(context, AgriStickStatusScreen());
      }
      setBarCodeLoader(false);
    } catch (error) {
      barCodeResult = "क्षमा करें कुछ त्रुटि हुई";
      setBarCodeLoader(false);
      agristickStatus = false;
      Utils.model(context, AgriStickStatusScreen());
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
      maxY = 0;
      maxLeafWetnessY = 0;
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
      int index = DateTime.parse(graphData[i]["createdAt"]).weekday;
      if (index == 7) {
        index = 0;
      }
      final leafWetness =
          double.parse(graphData[i]["averageLeafWetness"].replaceAll("%", ""));
      maxLeafWetnessY =
          maxLeafWetnessY < leafWetness ? leafWetness : maxLeafWetnessY;

      final soilMoisture =
          double.parse(graphData[i]["averageSoilMoisture"].replaceAll("%", ""));
      // final soilMoisture = double.parse(graphData[i]["averageSoilMoisture"]);
      maxY = maxY < soilMoisture ? soilMoisture : maxY;

      leafWetnessData.add(FlSpot(index.toDouble(), leafWetness));
      soilMoistureData.add(FlSpot(index.toDouble(), soilMoisture));
    }
  }
}
