import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/expense_income_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_income_forms.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_income_list_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class OldExpenseCropBasis extends HookWidget {
  const OldExpenseCropBasis(
      {super.key,
      required this.plotId,
      required this.cropHistoryId,
      required this.cropName,
      required this.cropNameHi});
  final String plotId;
  final String cropHistoryId;
  final String cropName;
  final String cropNameHi;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);
    final tabController = useTabController(initialLength: 2);
    useListenable(tabController);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.fetchExpenseIncome(
          context,
          plotId,
          cropHistoryId,
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
          "${AppLocalization.of(context).locale.toString() == "en" ? cropName : cropNameHi} ${AppLocalization.of(context).getTranslatedValue("expenseIncomeCalculator").toString()}",
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
              TabBarView(
                controller: tabController,
                children: const [
                  ExpenseSection(),
                  IncomeSection(),
                ],
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
    return InkWell(
      onTap: () => _showDetailsDialog(context),
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
  const IncomeSection({super.key});

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

  const IncomeTile({
    super.key,
    required this.income,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        "${income.yieldAmount.toStringAsFixed(0)} ${income.yieldUnit}",
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
    );
  }
}
