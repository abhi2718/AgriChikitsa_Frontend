import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../model/plots.dart';
import '../../../../../utils/utils.dart';

class SoilHealthChart extends HookWidget {
  const SoilHealthChart({super.key, required this.useViewModel, required this.selectedField});
  final dynamic useViewModel;
  final List<Color> gradientColors = const [
    Color(0xff12c2e9),
    Color(0xffc471ed),
    Color(0xfff64f59),
  ];

  final bool showAvg = false;
  final Plots selectedField;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    useEffect(() {
      useViewModel.getGraphData(context, selectedField);
    }, [useViewModel.selectedDate]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            AppLocalization.of(context).getTranslatedValue("soilWetness").toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: dimension['width']!,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black54, spreadRadius: 0, blurRadius: 1, offset: Offset(0, 2))
              ]),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.50,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 8,
                  top: 36,
                  bottom: 6,
                ),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22),
          child: Center(
            child: Text(
              AppLocalization.of(context).getTranslatedValue("leafWetness").toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: dimension['height']! * 0.35,
          width: dimension['width']!,
          margin: const EdgeInsets.only(top: 8, bottom: 28),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black54, spreadRadius: 0, blurRadius: 1, offset: Offset(0, 1))
              ]),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.50,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 8,
                  top: 36,
                  bottom: 6,
                ),
                child: LineChart(
                  leafWetness(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            interval: 1,
            getTitlesWidget: (value, TitleMeta) {
              final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
              if (value >= 0 && value < useViewModel.soilMoistureData.length) {
                final index = useViewModel.soilMoistureData[value.toInt()].x.toInt();
                if (index >= 0 && index < dayNames.length) {
                  return Text(
                    dayNames[index],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  );
                }
              }
              return const Text("");
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: useViewModel.maxY != 0 ? useViewModel.maxY / 4 : 30,
            getTitlesWidget: (value, TitleMeta) {
              return Text(
                "$value",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 50,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: useViewModel.soilMoistureData.length.toDouble() - 1,
      minY: 0,
      maxY: useViewModel.maxY != 0 ? useViewModel.maxY : 100,
      lineBarsData: [
        LineChartBarData(
          show: useViewModel.showGraph,
          spots: useViewModel.soilMoistureData,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData leafWetness() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            interval: 1,
            getTitlesWidget: (value, TitleMeta) {
              final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
              if (value >= 0 && value < useViewModel.leafWetnessData.length) {
                final index = useViewModel.leafWetnessData[value.toInt()].x.toInt();
                if (index >= 0 && index < dayNames.length) {
                  return Text(
                    dayNames[index],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  );
                }
              }
              return const Text("");
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: useViewModel.maxLeafWetnessY != 0 ? useViewModel.maxLeafWetnessY / 4 : 30,
            getTitlesWidget: (value, TitleMeta) {
              return Text(
                '$value',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 50,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: useViewModel.leafWetnessData.length.toDouble() - 1,
      minY: 0,
      maxY: useViewModel.maxLeafWetnessY != 0 ? useViewModel.maxLeafWetnessY : 100,
      lineBarsData: [
        LineChartBarData(
          show: useViewModel.showGraph,
          spots: useViewModel.leafWetnessData,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
