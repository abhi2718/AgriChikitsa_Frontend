import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/expense_income_model.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_income_forms.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

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
          AppLocalization.of(context).getTranslatedValue("expenseIncomeCalculator").toString(),
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
                padding: const EdgeInsets.only(bottom: 80),
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    ExpenseSection(),
                    IncomeSection(),
                  ],
                ),
              ),

              BottomFixedButtons(
                plot: selectedPlot,
                activeTabIndex: tabController.index,
                kamaiModel: vm.kamai,
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
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.expenses.isEmpty) {
          return Center(
              child: Text(
            AppLocalization.of(context).getTranslatedValue("noExpense").toString(),
          ));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.expenses.length,
          itemBuilder: (_, i) {
            return ExpenseTile(expense: vm.expenses[i]);
          },
        );
      },
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);

    return Card(
      surfaceTintColor: AppColor.whiteColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(AppLocalization.of(context).locale.toString() == "en"
            ? expense.category
            : getCategoryLabel(context, expense.category)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.subCategory),
            const SizedBox(height: 4),
            Text(
              "₹${expense.amount}  •  ${formatDate(expense.date)}",
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.edit),
            //   onPressed: () {
            //     final recordId = expense.recordId; // KharchaKamaiModel id stored in ExpenseModel
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => AddExpenseForm(
            //           recordId: recordId,
            //           expense: expense, // pass the existing expense to edit
            //         ),
            //       ),
            //     );
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await vm.deleteExpense(
                  context,
                  expense,
                );
              },
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
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.incomes.isEmpty) {
          return Center(
              child: Text(
            AppLocalization.of(context).getTranslatedValue("noIncome").toString(),
          ));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.incomes.length,
          itemBuilder: (_, i) {
            return IncomeTile(income: vm.incomes[i]);
          },
        );
      },
    );
  }
}

class IncomeTile extends StatelessWidget {
  final IncomeModel income;

  const IncomeTile({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          "${AppLocalization.of(context).getTranslatedValue("yieldAmount").toString()}: ${income.yieldAmount} ${income.yieldUnit}",
        ),
        subtitle: Text(
          "₹${income.totalIncome}\n${income.notes}",
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.edit),
            //   onPressed: () {
            //     final recordId = income.recordId; // KharchaKamaiModel id stored in ExpenseModel
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => AddIncomeForm(
            //           recordId: recordId,
            //           income: income, // pass the existing expense to edit
            //         ),
            //       ),
            //     );
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await vm.deleteIncome(
                  context,
                  income,
                );
              },
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

  const BottomFixedButtons(
      {super.key, required this.plot, required this.activeTabIndex, required this.kamaiModel});

  @override
  Widget build(BuildContext context) {
    final isKharchaTab = activeTabIndex == 0;
    final isKamaiTab = activeTabIndex == 1;

    final isFinalSubmitted = kamaiModel?.isFinalSubmitted == true;
    final isHarvesting = !plot.isHarvesting;
    final isKamaiActive = kamaiModel?.isKamaiActive == true;
    final hasIncome = (kamaiModel?.incomeRecords.length ?? 0) > 0;

    if (isFinalSubmitted) {
      return const SizedBox.shrink();
    }

    final showAddExpense = isKharchaTab;
    final showAddIncome = isKamaiTab && isHarvesting && isKamaiActive;
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
                        builder: (_) => AddIncomeForm(recordId: recordId),
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
