import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/expense_income_model.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_income_forms.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseIncomeListScreen extends HookWidget {
  const ExpenseIncomeListScreen({super.key, required this.selectedPlot});
  final Plots selectedPlot;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);
    final tabController = useTabController(initialLength: 2);
    useListenable(tabController);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.fetchExpenseIncome(
          context,
          selectedPlot.id,
          selectedPlot.cropHistoryId!,
        );
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.notificationBgColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading: vm.finalSubmitLoader
            ? SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text(
          "${AppLocalization.of(context).locale.toString() == "en" ? selectedPlot.cropName : selectedPlot.cropNameHi} ${AppLocalization.of(context).getTranslatedValue("expenseIncomeCalculator").toString()}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        bottom: TabBar(
          controller: tabController,
          labelColor: AppColor.darkBlackColor,
          indicatorColor: AppColor.extraDark,
          tabs: [
            Tab(
              text: AppLocalization.of(context).getTranslatedValue("expense").toString(),
            ),
            Tab(
              text: AppLocalization.of(context).getTranslatedValue("income").toString(),
            ),
          ],
        ),
      ),
      body: Consumer<ExpenseViewModel>(
        builder: (_, vm, __) {
          return Stack(
            children: [
              /// MAIN CONTENT
              Padding(
                padding: EdgeInsets.only(bottom: vm.kamai?.isFinalSubmitted == true ? 0 : 80),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ExpenseSection(),
                    IncomeSection(selectedPlot: selectedPlot),
                  ],
                ),
              ),

              BottomFixedButtons(
                plot: selectedPlot,
                activeTabIndex: tabController.index,
                kamaiModel: vm.kamai,
                selectedPlot: selectedPlot,
              ),

              if (vm.finalSubmitLoader)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.extraDark,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ExpenseSection extends StatelessWidget {
  const ExpenseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(
      builder: (_, vm, __) {
        if (vm.listLoader) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.extraDark,
          ));
        }

        if (vm.kamai == null || vm.expenses.isEmpty) {
          return Center(
              child: Text(
            AppLocalization.of(context).getTranslatedValue("noExpense").toString(),
          ));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// SUMMARY CARD
              ExpenseSummaryCard(kamai: vm.kamai!),
              ExpenseIncomeBarChart(
                kamai: vm.kamai!,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 16),
                child: Text(
                  AppLocalization.of(context).getTranslatedValue("allExpenses").toString(),
                  style: TextStyle(
                      color: AppColor.darkBlackColor, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

              /// LIST
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.expenses.length,
                  itemBuilder: (_, i) {
                    final isLast = i == vm.expenses.length - 1;
                    return ExpenseTile(
                      expense: vm.expenses[i],
                      isLast: isLast,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;
  final bool isLast;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.isLast,
  });

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getCategoryIcon(expense.category),
                  size: 20,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                getCategoryLabel(context, expense.category),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row(AppLocalization.of(context).getTranslatedValue("amount").toString(),
                  "₹${expense.amount.toStringAsFixed(0)}"),
              const SizedBox(height: 8),
              _row(AppLocalization.of(context).getTranslatedValue("subcategory").toString(),
                  expense.subCategory),
              const SizedBox(height: 8),
              _row(AppLocalization.of(context).getTranslatedValue("quantity").toString(),
                  "${expense.quantity != null ? expense.quantity!.toStringAsFixed(2) : ''} ${expense.unit ?? ''}"),
              _row(AppLocalization.of(context).getTranslatedValue("selectedDate").toString(),
                  formatFullDate(expense.date)),
              const SizedBox(height: 8),
              if (expense.description.isNotEmpty)
                _row(AppLocalization.of(context).getTranslatedValue("description").toString(),
                    expense.description),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);

    return InkWell(
      onTap: () => _showDetailsDialog(context),
      onLongPress: () => _showDeleteExpenseDialog(context, vm, expense),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// CATEGORY ICON
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                getCategoryIcon(expense.category),
                size: 20,
                color: Colors.green,
              ),
            ),

            const SizedBox(width: 12),

            /// MAIN CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Category + Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          getCategoryLabel(context, expense.category),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "₹${expense.amount.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Subcategory
                  Text(
                    expense.subCategory,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Amount
                  Text(
                    formatFullDate(expense.date),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeSection extends StatelessWidget {
  const IncomeSection({super.key, required this.selectedPlot});
  final Plots selectedPlot;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(
      builder: (_, vm, __) {
        if (vm.listLoader) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.extraDark,
          ));
        }

        if (!vm.kamai!.isKamaiActive && !vm.kamai!.isFinalSubmitted && vm.incomes.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColor.errorColor,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalization.of(context).getTranslatedValue("noKamaiActive").toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        if (vm.incomes.isEmpty) {
          return Center(
              child: Text(
            AppLocalization.of(context).getTranslatedValue("noIncome").toString(),
          ));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpenseSummaryCard(
                kamai: vm.kamai!,
                isIncomeScreen: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 16),
                child: Text(
                  AppLocalization.of(context).getTranslatedValue("allIncomes").toString(),
                  style: TextStyle(
                      color: AppColor.darkBlackColor, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.incomes.length,
                  itemBuilder: (_, i) {
                    final isLast = i == vm.incomes.length - 1;
                    return IncomeTile(
                      income: vm.incomes[i],
                      isLast: isLast,
                      selectedPlot: selectedPlot,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class IncomeTile extends StatelessWidget {
  final IncomeModel income;
  final bool isLast;
  final Plots selectedPlot;

  const IncomeTile({
    super.key,
    required this.income,
    required this.isLast,
    required this.selectedPlot,
  });

  String getLocalizedUnit(String key, Locale locale) {
    final unit = priceUnitMap.firstWhere(
      (e) => e.key == key,
      orElse: () => UnitOption(key: key, en: key, hi: key),
    );

    return locale.languageCode == 'hi' ? unit.hi : unit.en;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);

    return InkWell(
      onLongPress: () => _showDeleteIncomeDialog(context, vm, income, selectedPlot),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MAIN CONTENT (no icon)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Amount + Income capsule
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${income.yieldAmount.toStringAsFixed(0)} ${getLocalizedUnit(income.yieldUnit, AppLocalization.of(context).locale)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      /// TOTAL INCOME CAPSULE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "₹${income.totalIncome.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Notes
                  if ((income.notes ?? "").isNotEmpty)
                    Text(
                      income.notes!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                  const SizedBox(height: 6),

                  Text(
                    formatFullDate(income.saleDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomFixedButtons extends StatelessWidget {
  final Plots plot;
  final int activeTabIndex;
  final KharchaKamaiModel? kamaiModel;
  final Plots selectedPlot;

  const BottomFixedButtons(
      {super.key,
      required this.plot,
      required this.activeTabIndex,
      required this.kamaiModel,
      required this.selectedPlot});

  @override
  Widget build(BuildContext context) {
    final isKharchaTab = activeTabIndex == 0;
    final isKamaiTab = activeTabIndex == 1;
    final isFinalSubmitted = kamaiModel?.isFinalSubmitted == true;
    final isHarvesting = plot.isHarvesting;
    final isKamaiActive = kamaiModel?.isKamaiActive == true;
    final hasIncome = (kamaiModel?.incomeRecords.length ?? 0) > 0;

    if (isFinalSubmitted) {
      return const SizedBox.shrink();
    }

    final showAddExpense = isKharchaTab;
    final showAddIncome = isKamaiTab && isHarvesting && isKamaiActive && !hasIncome;
    final showFinalSubmit = isKamaiTab && isHarvesting && isKamaiActive && hasIncome;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// FINAL SUBMIT BUTTON (shown ABOVE add income)
            if (showFinalSubmit)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () async {
                    final vm = context.read<ExpenseViewModel>();

                    final success = await vm.finalSubmitKamai(
                      context,
                      kamaiModel!.id,
                    );

                    if (!context.mounted) return;

                    if (success) {
                      await Utils.showAutoCloseDialog(
                        context,
                        title: AppLocalization.of(context).getTranslatedValue("success").toString(),
                        message: AppLocalization.of(context)
                            .getTranslatedValue("finalSubmitSuccess")
                            .toString(),
                        success: true,
                      );
                    } else {
                      await Utils.showAutoCloseDialog(
                        context,
                        title:
                            AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
                        message: AppLocalization.of(context)
                            .getTranslatedValue("finalSubmitFailed")
                            .toString(),
                        success: false,
                      );
                    }
                  },
                  child: GradientButton(
                    width: double.infinity,
                    title: AppLocalization.of(context).getTranslatedValue("finalSubmit").toString(),
                  ),
                ),
              ),

            /// ADD EXPENSE / ADD INCOME BUTTON
            if (showAddExpense || showAddIncome)
              InkWell(
                onTap: () {
                  final vm = context.read<ExpenseViewModel>();
                  final recordId = vm.kamai?.id;

                  if (recordId == null) {
                    Utils.flushBarErrorMessage(
                      AppLocalization.of(context).getTranslatedValue("alert").toString(),
                      "Expense record not created yet",
                      context,
                    );
                    return;
                  }

                  if (showAddExpense) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddExpenseForm(recordId: recordId),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddIncomeForm(recordId: recordId, selectedPlot: selectedPlot),
                      ),
                    );
                  }
                },
                child: GradientButton(
                  width: double.infinity,
                  title: showAddExpense
                      ? AppLocalization.of(context).getTranslatedValue("addExpense").toString()
                      : AppLocalization.of(context).getTranslatedValue("addIncome").toString(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.year}";
}

class ExpenseSummaryCard extends StatelessWidget {
  final KharchaKamaiModel kamai;
  final bool isIncomeScreen;
  const ExpenseSummaryCard({super.key, required this.kamai, this.isIncomeScreen = false});

  @override
  Widget build(BuildContext context) {
    final totals = kamai.totalExpenditures;

    Widget row(String key, double value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              getCategoryIcon(key),
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                getCategoryLabel(context, key),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              "₹${value.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final totalExpense = totals.grandTotal;
    final netProfit = kamai.netProfit;

    double percentage;

    if (totalExpense == 0) {
      percentage = netProfit > 0
          ? 100
          : netProfit < 0
              ? -100
              : 0;
    } else {
      percentage = (netProfit / totalExpense) * 100;
    }

    final bool isLoss = percentage < 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.extraDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,

          /// HEADER CONTENT
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NET PROFIT
              kamai.isFinalSubmitted || kamai.isKamaiActive
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue("netProfit")
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "₹${netProfit.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 24,
                        ),

                        /// Percentage Capsule
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isLoss ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "${percentage.toStringAsFixed(0)}%",
                            style: TextStyle(
                              color: isLoss ? Colors.white : Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: kamai.isFinalSubmitted || kamai.isKamaiActive ? 6 : 0),

              /// GRAND TOTAL
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(context).getTranslatedValue("totalExpense").toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "₹${totals.grandTotal.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(context).getTranslatedValue("totalIncome").toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "₹${kamai.totalIncome.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          /// EXPANDED CONTENT
          children: [
            row("seeds", totals.seeds),
            row("fertilisers", totals.fertilisers),
            row("pesticides", totals.pesticides),
            row("machinery", totals.machinery),
            row("labour", totals.labour),
            row("irrigation", totals.irrigation),
            row("electricity", totals.electricity),
            row("harvest", totals.harvest),
            row("other", totals.other),
          ],
        ),
      ),
    );
  }
}

class ExpenseIncomeBarChart extends StatelessWidget {
  final KharchaKamaiModel kamai;

  const ExpenseIncomeBarChart({
    super.key,
    required this.kamai,
  });

  double _getMaxY(List<double> categoryData) {
    double maxVal = 0;

    for (final value in categoryData) {
      if (value > maxVal) {
        maxVal = value;
      }
    }

    if (maxVal == 0) return 100;

    final rounded = (maxVal / 1000).ceil() * 1000;
    return rounded * 1.2; // little headroom
  }

  @override
  Widget build(BuildContext context) {
    final totals = kamai.totalExpenditures;

    final categoryData = [
      totals.seeds,
      totals.fertilisers,
      totals.pesticides,
      totals.machinery,
      totals.labour,
      totals.irrigation,
      totals.electricity,
      totals.harvest,
      totals.other,
    ];
    final maxY = _getMaxY(categoryData);

    return Container(
      height: 300,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 12),
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade500, spreadRadius: 0, blurRadius: 5)]),
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: maxY,
          groupsSpace: 20,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: AppColor.extraDark),
              bottom: BorderSide(color: AppColor.extraDark),
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: maxY / 5,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      "₹${value.toInt()}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= expenseCategories.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      expenseCategories[index].icon,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(categoryData.length, (index) {
            final expenseValue = categoryData[index];

            return BarChartGroupData(
              x: index,
              barRods: [
                /// Expense Bar
                BarChartRodData(
                  toY: expenseValue,
                  color: Colors.green.shade700,
                  width: 12,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
              ],
            );
          }),
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => AppColor.extraDark,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final category = expenseCategories[group.x.toInt()];
                final label = AppLocalization.of(context).locale == "em"
                    ? category.englishLabel
                    : category.hindiLabel;

                return BarTooltipItem(
                  "$label\n₹${rod.toY.toInt()}",
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

String formatFullDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

void _showDeleteExpenseDialog(BuildContext context, ExpenseViewModel vm, ExpenseModel expense) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          AppLocalization.of(context).getTranslatedValue("deleteExpense").toString(),
        ),
        content: Text(
          AppLocalization.of(context).getTranslatedValue("deleteExpenseConfirm").toString(),
        ),
        actions: [
          TextButton(
            child: BaseText(
              title: AppLocalization.of(context).getTranslatedValue("no").toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.extraDark,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: BaseText(
              title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.errorColor,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await vm.deleteExpense(context, expense);
            },
          ),
        ],
      );
    },
  );
}

void _showDeleteIncomeDialog(
    BuildContext context, ExpenseViewModel vm, IncomeModel income, Plots selectedPlot) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          AppLocalization.of(context).getTranslatedValue("deleteIncome").toString(),
        ),
        content: Text(
          AppLocalization.of(context).getTranslatedValue("deleteIncomeConfirm").toString(),
        ),
        actions: [
          TextButton(
            child: BaseText(
              title: AppLocalization.of(context).getTranslatedValue("no").toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.extraDark,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: BaseText(
              title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.errorColor,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await vm.deleteIncome(context, income, selectedPlot);
            },
          ),
        ],
      );
    },
  );
}
