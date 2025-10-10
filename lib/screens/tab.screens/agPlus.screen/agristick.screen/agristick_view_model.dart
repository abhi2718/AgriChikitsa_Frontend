import 'dart:developer';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agristick.screen/widgets/activateAgristickStatusScreen.dart';
import 'package:agriChikitsa/widgets/scanner/qr_scanner_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

import '../../../../model/plots.dart';
import '../../../../repository/AG+.repo/ag_plus_repository.dart';
import '../../../../utils/utils.dart';

class AgristickViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  List<dynamic> graphData = [];
  List<FlSpot> leafWetnessData = [];
  List<FlSpot> soilMoistureData = [];
  List<String> dateLabels = [];
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
    leafWetnessData.clear();
    soilMoistureData.clear();
    dateLabels.clear();
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
    try {
      final barCodeScanRes = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (_) => const QRScannerScreen()),
          ) ??
          "-1";

      barCodeResult = barCodeScanRes == "-1"
          ? AppLocalization.of(context).getTranslatedValue("scanFailed").toString()
          : barCodeScanRes;

      if (barCodeScanRes != "-1") {
        setBarCodeLoader(true);
        activateAgristick(context, currentField);
      }

      notifyListeners();
    } catch (e) {
      barCodeResult = "Failed to scan barcode";
      notifyListeners();
    }
  }

  void activateAgristick(BuildContext context, Plots currentField) async {
    try {
      final data = await _agPlusRepository.activateAgristick(barCodeResult, currentField.id);
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
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  //Old Implementation
  // void getGraphData(BuildContext context, Plots currentField) async {
  //   showGraph = false;
  //   try {
  //     soilMoistureData = [];
  //     leafWetnessData = [];
  //     maxY = 0;
  //     maxLeafWetnessY = 0;
  //     final data = await _agPlusRepository.getGraphData(
  //         currentField.agristick['_id'], selectedDate.toLocal().toString().split(' ')[0]);
  //     graphData = data['averageFieldData'];
  //     setFlData();
  //     showGraph = true;
  //     notifyListeners();
  //   } catch (error) {
  //     if (kDebugMode) {
  //       Utils.flushBarErrorMessage(
  //           AppLocalization.of(context).getTranslatedValue("alert").toString(),
  //           error.toString(),
  //           context);
  //     }
  //   }
  // }

  void getGraphData(BuildContext context, Plots currentField) async {
    showGraph = false;
    try {
      soilMoistureData = [];
      leafWetnessData = [];
      dateLabels = [];
      maxY = 0;
      maxLeafWetnessY = 0;

      // Fetch data
      final data =
          await _agPlusRepository.getGraphData(selectedDate.toLocal().toString().split(' ')[0]);

      if (data != null && data['feeds'] != null) {
        final List<dynamic> feeds = data['feeds'];
        final DateTime endDate = selectedDate;
        final DateTime startDate = endDate.subtract(Duration(days: 30));

        // Use a map to ensure unique dates and retain the latest data
        final Map<String, Map<String, double>> uniqueDateData = {};
        final Map<String, DateTime> dateTracker = {}; // Tracks the latest timestamp for each date

        for (var feed in feeds) {
          final DateTime createdAt = DateTime.parse(feed['created_at']);
          final String formattedDate = DateFormat('d MMM').format(createdAt);

          if (createdAt.isAfter(startDate) && createdAt.isBefore(endDate)) {
            final double? leafWetnessValue =
                feed['field1'] != null ? double.tryParse(feed['field1']) : null;
            final double? soilMoistureValue =
                feed['field2'] != null ? double.tryParse(feed['field2']) : null;

            // If the date is not yet in the map, or this feed is newer, update the map
            if (!uniqueDateData.containsKey(formattedDate) ||
                createdAt.isAfter(dateTracker[formattedDate]!)) {
              uniqueDateData[formattedDate] = {
                'leafWetness': leafWetnessValue ?? 0.0,
                'soilMoisture': soilMoistureValue ?? 0.0,
              };
              dateTracker[formattedDate] = createdAt; // Update the latest timestamp for the date
            }
          }
        }

        int index = 0; // For tracking data points on the x-axis
        uniqueDateData.forEach((date, values) {
          // Add data points to the chart
          soilMoistureData.add(FlSpot(index.toDouble(), values['soilMoisture']!));
          leafWetnessData.add(FlSpot(index.toDouble(), values['leafWetness']!));
          dateLabels.add(date);

          // Update max values
          maxY = values['soilMoisture']! > maxY ? values['soilMoisture']! : maxY;
          maxLeafWetnessY =
              values['leafWetness']! > maxLeafWetnessY ? values['leafWetness']! : maxLeafWetnessY;

          index++;
        });
      }

      showGraph = true;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  void setFlData() {
    for (int i = 0; i < graphData.length; i++) {
      int index = DateTime.parse(graphData[i]["createdAt"]).weekday;
      if (index == 7) {
        index = 0;
      }
      final leafWetness = double.parse(graphData[i]["averageLeafWetness"].replaceAll("%", ""));
      maxLeafWetnessY = maxLeafWetnessY < leafWetness ? leafWetness : maxLeafWetnessY;

      final soilMoisture = double.parse(graphData[i]["averageSoilMoisture"].replaceAll("%", ""));
      maxY = maxY < soilMoisture ? soilMoisture : maxY;

      leafWetnessData.add(FlSpot(index.toDouble(), leafWetness));
      soilMoistureData.add(FlSpot(index.toDouble(), soilMoisture));
    }
  }
}
