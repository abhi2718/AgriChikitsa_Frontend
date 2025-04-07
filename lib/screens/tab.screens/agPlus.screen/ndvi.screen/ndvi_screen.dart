import 'package:agriChikitsa/model/ndvi_model.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ndvi.screen/ndvi_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NDVIScreen extends HookWidget {
  const NDVIScreen({super.key, required this.selectedPlot});
  final Plots selectedPlot;

  IconData _getStatusIcon(int? statusCode) {
    switch (statusCode) {
      case 200:
        return Icons.check_circle;
      case 400:
        return Icons.warning_amber_rounded;
      case 404:
        return Icons.help_outline;
      case 422:
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<NDVIViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.reinitialize();
      useViewModel.getCropHealthStatus(context, selectedPlot.ndviId!, "1");
    }, []);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("cropMonitoringTitle").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<NDVIViewModel>(builder: (context, provider, child) {
        return provider.responseLoader
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.darkColor,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
                  child: Column(
                    children: [
                      //Graoh showing ndvi values
                      NDVIGraph(
                        ndviData: provider.ndviResponse!,
                        ndviId: selectedPlot.ndviId!,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Consumer<NDVIViewModel>(
                        builder: (context, provider, child) {
                          final ndviResponse = provider.ndviResponse;
                          final Color statusColor = ndviResponse?.statusColor ?? Colors.grey;
                          final String message =
                              AppLocalization.of(context).locale.toString() == "en"
                                  ? ndviResponse?.messageEn ?? "No data available"
                                  : ndviResponse?.messageHi ?? "कोई डेटा मौजूद नहीं।";

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  _getStatusIcon(ndviResponse?.statusCode),
                                  color: statusColor,
                                  size: 36,
                                ),
                                const SizedBox(width: 22),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message,
                                        style: TextStyle(
                                          color: ndviResponse?.statusCode == 422
                                              ? statusColor
                                              : AppColor.darkBlackColor, // Conditional text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                        width: dimension["width"],
                        // height: dimension["height"]! * 0.42,
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ndviTasksHeader
                            Center(
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("ndviTasksHeader")
                                    .toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              AppLocalization.of(context).locale.toString() == "en"
                                  ? provider.ndviResponse!.advisoryEn
                                  : provider.ndviResponse!.advisoryHi,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

class NDVIGraph extends StatefulWidget {
  const NDVIGraph({super.key, required this.ndviData, required this.ndviId});
  final NDVIResponse ndviData;
  final String ndviId;

  @override
  _NDVIGraphState createState() => _NDVIGraphState();
}

class _NDVIGraphState extends State<NDVIGraph> {
  final List<Color> gradientColors = const [
    Color(0xFF006400), // DarkGreen
    Color(0xFF228B22), // ForestGreen
    Color(0xFF2E8B57),
  ];

  int currentPage = 1;
  final int maxVisiblePoints = 5;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<NDVIViewModel>(context, listen: false);
    final dimension = Utils.getDimensions(context, true);
    final int totalPages = (widget.ndviData.totalRecords / maxVisiblePoints).ceil();
    final bool canGoBack = currentPage > 1;
    final bool canGoForward = currentPage < totalPages;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.ndviData.currentStaging,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: canGoBack ? Colors.black : Colors.grey),
                    onPressed: canGoBack
                        ? () async {
                            if (!isLoading) {
                              setState(() {
                                isLoading = true;
                              });
                              bool success = await useViewModel.getCropHealthStatus(
                                  context, widget.ndviId, (currentPage - 1).toString());
                              if (success) {
                                setState(() {
                                  currentPage--;
                                });
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        color: canGoForward ? Colors.black : Colors.grey),
                    onPressed: canGoForward
                        ? () async {
                            if (!isLoading) {
                              setState(() {
                                isLoading = true;
                              });
                              bool success = await useViewModel.getCropHealthStatus(
                                  context, widget.ndviId, (currentPage + 1).toString());
                              if (success) {
                                setState(() {
                                  currentPage++;
                                });
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: dimension['width']!,
            margin: const EdgeInsets.only(top: 8),
            child: AspectRatio(
              aspectRatio: 1.50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "NDVI",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        left: 8,
                        top: 36,
                        bottom: 6,
                      ),
                      child: LineChart(
                        mainData(widget.ndviData.ndviHistory),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(List<NDVIHistory> ndviHistory) {
    List<FlSpot> ndviPoints = ndviHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.ndviValue);
    }).toList();

    List<String> dateLabels = ndviHistory.map((e) {
      return DateFormat("d MMM").format(e.date);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 0.15,
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
            getTitlesWidget: (value, meta) {
              if (value >= 0 && value < dateLabels.length) {
                return Text(
                  dateLabels[value.toInt()],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                );
              }
              return const Text("");
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.15,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(2),
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
      maxX: ndviPoints.length.toDouble() - 1,
      minY: 0,
      maxY: 1,
      lineBarsData: [
        LineChartBarData(
          show: true,
          spots: ndviPoints,
          isCurved: false,
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
