import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/expense_income_model.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_income_list_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/plotHistory.screen/plot_history.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ExpenseIncomeTracker extends HookWidget {
  const ExpenseIncomeTracker({super.key, required this.selectedPlot});
  final Plots selectedPlot;
  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(() => Provider.of<ExpenseViewModel>(context, listen: false));
    final authService = useMemoized(() => Provider.of<AuthService>(context, listen: false));
    final userId = authService.userInfo["user"]["_id"];
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (selectedPlot.kharchaKamaiRecord == null) {
          useViewModel.createRecord(
              context, selectedPlot, userId, selectedPlot.id, selectedPlot.cropHistoryId!);
        } else {
          useViewModel.fetchExpenseIncome(context, selectedPlot.id, selectedPlot.cropHistoryId!);
          useViewModel.getProfitBreakdownByField(context, selectedPlot.id);
        }
      });
      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.notificationBgColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalization.of(context).getTranslatedValue("expenseIncomeCalculator").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ActionButtonsCard(plot: selectedPlot),
            Consumer<ExpenseViewModel>(
              builder: (_, vm, __) {
                if (vm.profitLoader) {
                  return SizedBox();
                  //Can be used later
                  // return Container(
                  //   height: 340,
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.25),
                  //         blurRadius: 12,
                  //         offset: const Offset(4, 8),
                  //       ),
                  //     ],
                  //   ),
                  //   child: const Center(
                  //     child: SizedBox(
                  //       height: 30,
                  //       width: 30,
                  //       child: CircularProgressIndicator(
                  //         color: AppColor.extraDark,
                  //         strokeWidth: 3,
                  //       ),
                  //     ),
                  //   ),
                  // );
                }

                if (vm.cropProfits.isEmpty) {
                  return const SizedBox();
                }

                return CropProfitChart(
                  crops: vm.cropProfits,
                  currentPage: vm.currentPage,
                  totalPages: vm.totalPages,
                  onNext: vm.currentPage < vm.totalPages
                      ? () => vm.getProfitBreakdownByField(
                            context,
                            selectedPlot.id,
                            page: vm.currentPage + 1,
                          )
                      : null,
                  onPrev: vm.currentPage > 1
                      ? () => vm.getProfitBreakdownByField(
                            context,
                            selectedPlot.id,
                            page: vm.currentPage - 1,
                          )
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButtonsCard extends StatelessWidget {
  final Plots plot;

  const ActionButtonsCard({super.key, required this.plot});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseIncomeListScreen(
                    selectedPlot: plot,
                  ),
                ),
              );
            },
            child: GradientButton(
              height: dimension["height"]! * 0.08,
              width: dimension["width"]!,
              title: AppLocalization.of(context).getTranslatedValue("addExpenseBtn").toString(),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlotHistoryScreen(
                    selectedPlot: plot,
                  ),
                ),
              );
            },
            child: GradientButton(
              height: dimension["height"]! * 0.08,
              width: dimension["width"]!,
              title: AppLocalization.of(context).getTranslatedValue("oldCropsBtn").toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class CropProfitChart extends StatelessWidget {
  final List<CropProfitModel> crops;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;

  const CropProfitChart({
    super.key,
    required this.crops,
    required this.currentPage,
    required this.totalPages,
    this.onNext,
    this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    double minY = 0;

    for (final crop in crops) {
      if (crop.netProfit > maxY) maxY = crop.netProfit;
      if (crop.netProfit < minY) minY = crop.netProfit;
    }

    final roundedMax = (maxY / 1000).ceil() * 1000;
    final roundedMin = (minY / 1000).floor() * 1000;

    return Container(
      height: 340,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(4, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ───── Header with Navigation ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalization.of(context).getTranslatedValue("cropWiseProfitTitle").toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onPrev,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: onPrev == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: onNext,
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: onNext == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 10),

          /// ───── Chart ─────
          Expanded(
            child: BarChart(
              BarChartData(
                groupsSpace: 16,
                minY: roundedMin.toDouble(),
                maxY: roundedMax.toDouble(),
                baselineY: 0,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: AppColor.extraDark),
                    bottom: BorderSide(color: AppColor.extraDark),
                  ),
                ),

                /// ───── Tooltip ─────
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final crop = crops[group.x.toInt()];
                      return BarTooltipItem(
                        "${crop.cropNameHi ?? crop.cropName}\n₹${crop.netProfit.toStringAsFixed(0)}",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),

                /// ───── Titles ─────
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  /// Left Axis
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: (roundedMax - roundedMin) / 4,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "₹${value.toInt()}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),

                  /// Bottom Axis (Crop Image)
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= crops.length) {
                          return const SizedBox();
                        }

                        final crop = crops[value.toInt()];

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              crop.cropImage,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                /// ───── Bars ─────
                barGroups: List.generate(crops.length, (index) {
                  final profit = crops[index].netProfit;

                  final isPositive = profit >= 0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: profit.toDouble(),
                        width: 18,
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isPositive
                              ? [Colors.green.shade400, Colors.green.shade700]
                              : [Colors.red.shade400, Colors.red.shade700],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
