import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/expense_income_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class AddExpenseForm extends HookWidget {
  final String recordId;
  final ExpenseModel? expense; // null = add, not null = edit

  const AddExpenseForm({
    super.key,
    required this.recordId,
    this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEdit = expense != null;
    final dimension = Utils.getDimensions(context, true);
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);
    final formKey = useMemoized(
      () => GlobalKey<FormState>(),
      [expense?.id],
    );

    useEffect(() {
      if (expense != null) {
        vm.setExpenseCategory(expense!.category);
        vm.setExpenseSubCategory(expense!.subCategory);
        vm.setExpenseAmount(expense!.amount);
        vm.setExpenseDate(expense!.date);
        vm.setExpenseDescription(expense!.description);
      }
      return vm.clearExpenseForm;
    }, []);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        expense != null
            ? AppLocalization.of(context).getTranslatedValue("editExpense").toString()
            : AppLocalization.of(context).getTranslatedValue("addExpense").toString(),
      )),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// CATEGORY
                  DropdownButtonFormField<String>(
                    initialValue: vm.expenseCategory.isEmpty ? null : vm.expenseCategory,
                    items: expenseCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.key,
                            child: Row(
                              children: [
                                Icon(category.icon, size: 18),
                                const SizedBox(width: 8),
                                Text(getCategoryLabel(context, category.key)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => vm.setExpenseCategory(val!),
                    validator: (val) => val == null ? "Select category" : null,
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context)
                          .getTranslatedValue("selectCategoryPost")
                          .toString(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// SUB CATEGORY
                  TextFormField(
                    initialValue: vm.expenseSubCategory,
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("subcategory").toString(),
                    ),
                    onChanged: vm.setExpenseSubCategory,
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),

                  const SizedBox(height: 12),

                  /// AMOUNT
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("amount").toString(),
                    ),
                    onChanged: (v) => vm.setExpenseAmount(double.tryParse(v) ?? 0),
                    validator: (v) =>
                        v == null || double.tryParse(v) == null ? "Enter valid amount" : null,
                  ),

                  const SizedBox(height: 12),

                  /// DATE
                  Consumer<ExpenseViewModel>(
                    builder: (_, vm, __) {
                      return InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDate: vm.expenseDate ?? DateTime.now(),
                          );
                          if (picked != null) {
                            vm.setExpenseDate(picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: greenOutlinedInput(
                            AppLocalization.of(context).getTranslatedValue("selectDate").toString(),
                          ),
                          child: Text(
                            vm.expenseDate == null
                                ? ""
                                : vm.expenseDate!.toString().split(" ").first,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  /// DESCRIPTION
                  TextFormField(
                    maxLines: 3,
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("description").toString(),
                    ),
                    onChanged: vm.setExpenseDescription,
                  ),
                ],
              ),
            ),
          ),

          /// SAVE BUTTON
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;

                  final expenseModel = vm.buildExpenseFromForm();
                  if (expenseModel == null) return;

                  if (expense != null) {
                    // 🔁 EDIT MODE
                    await vm.updateExpense(
                      context,
                      recordId,
                      expense!.id!,
                      expenseModel,
                    );
                  } else {
                    // ➕ ADD MODE
                    await vm.addExpense(
                      context,
                      recordId,
                      expenseModel,
                    );
                  }

                  vm.clearExpenseForm();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: GradientButton(
                  height: dimension["height"]! * 0.1,
                  width: double.infinity,
                  title: AppLocalization.of(context).getTranslatedValue("save").toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddIncomeForm extends HookWidget {
  final String recordId;
  final IncomeModel? income;

  const AddIncomeForm({
    super.key,
    required this.recordId,
    this.income,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEdit = income != null;
    final dimension = Utils.getDimensions(context, true);
    final vm = Provider.of<ExpenseViewModel>(context, listen: false);
    final formKey = useMemoized(
      () => GlobalKey<FormState>(),
      [income?.id],
    );

    useEffect(() {
      if (income != null) {
        vm.setYieldAmount(income!.yieldAmount);
        vm.setYieldUnit(income!.yieldUnit);
        vm.setSellingPrice(income!.sellingPrice);
        vm.setPriceUnit(income!.priceUnit);
        vm.setSaleDate(income!.saleDate);
        vm.setIncomeNotes(income!.notes);
      }
      return vm.clearIncomeForm;
    }, []);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        income != null
            ? AppLocalization.of(context).getTranslatedValue("editIncome").toString()
            : AppLocalization.of(context).getTranslatedValue("addIncome").toString(),
      )),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("yieldAmount").toString(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setYieldAmount(double.tryParse(v) ?? 0),
                    validator: (v) => v == null || double.tryParse(v) == null ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: vm.yieldUnit,
                    items: const [
                      DropdownMenuItem(value: 'quintal', child: Text('Quintal')),
                      DropdownMenuItem(value: 'kg', child: Text('Kg')),
                      DropdownMenuItem(value: 'ton', child: Text('Ton')),
                    ],
                    onChanged: (val) {
                      if (val != null) vm.setYieldUnit(val);
                    },
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("yieldUnit").toString(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("sellingPrice").toString(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setSellingPrice(double.tryParse(v) ?? 0),
                    validator: (v) => v == null || double.tryParse(v) == null ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  Consumer<ExpenseViewModel>(
                    builder: (_, vm, __) {
                      return InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDate: vm.saleDate ?? DateTime.now(),
                          );
                          if (picked != null) {
                            vm.setSaleDate(picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: greenOutlinedInput(
                            AppLocalization.of(context).getTranslatedValue("selectDate").toString(),
                          ),
                          child: Text(
                            vm.saleDate == null ? "" : vm.saleDate!.toString().split(" ").first,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: greenOutlinedInput(
                      AppLocalization.of(context).getTranslatedValue("notes").toString(),
                    ),
                    onChanged: vm.setIncomeNotes,
                  ),
                ],
              ),
            ),
          ),

          /// SAVE BUTTON
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;

                  final incomeModel = vm.buildIncomeFromForm();
                  if (incomeModel == null) return;

                  if (income != null) {
                    // 🔁 EDIT MODE
                    await vm.updateIncome(
                      context,
                      recordId,
                      income!.id!,
                      incomeModel,
                    );
                  } else {
                    // ➕ ADD MODE
                    await vm.addIncome(
                      context,
                      recordId,
                      incomeModel,
                    );
                  }

                  vm.clearIncomeForm();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: GradientButton(
                  height: dimension["height"]! * 0.1,
                  width: double.infinity,
                  title: AppLocalization.of(context).getTranslatedValue("save").toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<ExpenseCategoryData> expenseCategories = [
  ExpenseCategoryData(
    key: 'seeds',
    englishLabel: 'Seeds / Nursery',
    hindiLabel: 'बीज',
    icon: Icons.grass,
  ),
  ExpenseCategoryData(
    key: 'fertilisers',
    englishLabel: 'Fertilisers',
    hindiLabel: 'उर्वरक',
    icon: Icons.spa,
  ),
  ExpenseCategoryData(
    key: 'pesticides',
    englishLabel: 'Pesticides',
    hindiLabel: 'कीटनाशक',
    icon: Icons.bug_report,
  ),
  ExpenseCategoryData(
    key: 'machinery',
    englishLabel: 'Machinery',
    hindiLabel: 'मशीनरी',
    icon: Icons.agriculture,
  ),
  ExpenseCategoryData(
    key: 'labour',
    englishLabel: 'Labour',
    hindiLabel: 'मजदूरी',
    icon: Icons.people,
  ),
  ExpenseCategoryData(
    key: 'irrigation',
    englishLabel: 'Irrigation',
    hindiLabel: 'सिंचाई',
    icon: Icons.water_drop,
  ),
  ExpenseCategoryData(
    key: 'electricity',
    englishLabel: 'Electricity',
    hindiLabel: 'बिजली',
    icon: Icons.electric_bolt,
  ),
  ExpenseCategoryData(
    key: 'harvest',
    englishLabel: 'Harvest',
    hindiLabel: 'कटाई',
    icon: Icons.content_cut,
  ),
  ExpenseCategoryData(
    key: 'other',
    englishLabel: 'Other',
    hindiLabel: 'अन्य',
    icon: Icons.category,
  ),
];

ExpenseCategoryData getExpenseCategory(String key) {
  return expenseCategories.firstWhere(
    (element) => element.key == key,
    orElse: () => expenseCategories.last,
  );
}

String getCategoryLabel(BuildContext context, String key) {
  final isHindi = AppLocalization.of(context).locale.toString() == 'hi';
  final category = getExpenseCategory(key);
  return isHindi ? category.hindiLabel : category.englishLabel;
}

IconData getCategoryIcon(String key) {
  return getExpenseCategory(key).icon;
}

InputDecoration greenOutlinedInput(String label) {
  return InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColor.extraDark,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColor.extraDark,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
}
