import 'dart:developer';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/expense_income_model.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:agriChikitsa/repository/expenseTracker.repo/expense_tracker.dart';
import 'package:flutter/material.dart';

class ExpenseViewModel with ChangeNotifier {
  final _repo = ExpenseTrackerRepository();

  /* --------------------------------------------------
   * LOADERS
   * -------------------------------------------------- */

  bool _expenseLoader = false;
  bool _incomeLoader = false;
  bool _listLoader = false;
  bool _finalSubmitLoader = false;

  bool get expenseLoader => _expenseLoader;
  bool get incomeLoader => _incomeLoader;
  bool get listLoader => _listLoader;
  bool get finalSubmitLoader => _finalSubmitLoader;

  void _setLoader(String type, bool value) {
    if (type == 'expense') _expenseLoader = value;
    if (type == 'income') _incomeLoader = value;
    if (type == 'list') _listLoader = value;
    if (type == 'finalSubmit') _finalSubmitLoader = value;
    notifyListeners();
  }

  /* --------------------------------------------------
   * STATE ARRAYS (SOURCE OF TRUTH FOR UI)
   * -------------------------------------------------- */
  KharchaKamaiModel? kamai;
  final List<ExpenseModel> _expenses = [];
  final List<IncomeModel> _incomes = [];

  List<ExpenseModel> get expenses => _expenses;
  List<IncomeModel> get incomes => _incomes;

  /* --------------------------------------------------
   * EXPENSE FORM STATE
   * -------------------------------------------------- */

  String _expenseCategory = '';
  String _expenseSubCategory = '';
  double _expenseAmount = 0;
  DateTime? _expenseDate;
  String _expenseDescription = '';

  String get expenseCategory => _expenseCategory;
  String get expenseSubCategory => _expenseSubCategory;
  double get expenseAmount => _expenseAmount;
  DateTime? get expenseDate => _expenseDate;
  String get expenseDescription => _expenseDescription;
  void setExpenseCategory(String value) {
    _expenseCategory = value;
    notifyListeners();
  }

  void setExpenseSubCategory(String value) {
    _expenseSubCategory = value;
    notifyListeners();
  }

  void setExpenseAmount(double value) {
    _expenseAmount = value;
    notifyListeners();
  }

  void setExpenseDate(DateTime value) {
    _expenseDate = value;
    notifyListeners();
  }

  void setExpenseDescription(String value) {
    _expenseDescription = value;
    notifyListeners();
  }

  ExpenseModel? buildExpenseFromForm() {
    if (_expenseCategory.trim().isEmpty) {
      Utils.toastMessage("Please select expense category");
      return null;
    }

    // sub-category
    if (_expenseSubCategory.trim().isEmpty) {
      Utils.toastMessage("Please enter sub category");
      return null;
    }

    // amount
    if (_expenseAmount <= 0) {
      Utils.toastMessage("Please enter valid expense amount");
      return null;
    }

    // date
    if (_expenseDate == null) {
      Utils.toastMessage("Please select expense date");
      return null;
    }

    // description is optional → trim only
    final description = _expenseDescription == null ? null : _expenseDescription!.trim();
    return ExpenseModel(
      recordId: "",
      category: _expenseCategory.trim(),
      subCategory: _expenseSubCategory.trim(),
      amount: _expenseAmount,
      date: _expenseDate!,
      description: description!,
    );
  }

  void clearExpenseForm() {
    _expenseCategory = '';
    _expenseSubCategory = '';
    _expenseAmount = 0;
    _expenseDate = null;
    _expenseDescription = '';
  }

  /* --------------------------------------------------
   * INCOME FORM STATE
   * -------------------------------------------------- */

  double _yieldAmount = 0;
  String _yieldUnit = 'kg';
  double _sellingPrice = 0;
  String _priceUnit = 'kg';
  DateTime? _saleDate;
  String _incomeNotes = '';

  double get yieldAmount => _yieldAmount;
  String get yieldUnit => _yieldUnit;
  double get sellingPrice => _sellingPrice;
  String get priceUnit => _priceUnit;
  DateTime? get saleDate => _saleDate;
  String get incomeNotes => _incomeNotes;

  double get totalIncome => _yieldAmount * _sellingPrice;
  void setYieldAmount(double value) {
    _yieldAmount = value;
    notifyListeners();
  }

  void setYieldUnit(String value) {
    _yieldUnit = value;
    notifyListeners();
  }

  void setSellingPrice(double value) {
    _sellingPrice = value;
    notifyListeners();
  }

  void setPriceUnit(String value) {
    _priceUnit = value;
    notifyListeners();
  }

  void setSaleDate(DateTime value) {
    _saleDate = value;
    notifyListeners();
  }

  void setIncomeNotes(String value) {
    _incomeNotes = value;
    notifyListeners();
  }

  IncomeModel? buildIncomeFromForm() {
    // yield amount
    if (_yieldAmount <= 0) {
      Utils.toastMessage("Please enter valid yield amount");
      return null;
    }

    // yield unit
    if (_yieldUnit.trim().isEmpty) {
      Utils.toastMessage("Please select yield unit");
      return null;
    }

    // selling price
    if (_sellingPrice <= 0) {
      Utils.toastMessage("Please enter valid selling price");
      return null;
    }

    // price unit
    if (_priceUnit.trim().isEmpty) {
      Utils.toastMessage("Please select price unit");
      return null;
    }

    // total income (derived but still must be valid)
    if (totalIncome <= 0) {
      Utils.toastMessage("Total income is invalid");
      return null;
    }

    // sale date
    if (_saleDate == null) {
      Utils.toastMessage("Please select sale date");
      return null;
    }

    // notes are optional → trim
    final notes = _incomeNotes == null ? null : _incomeNotes!.trim();
    return IncomeModel(
      recordId: "",
      yieldAmount: _yieldAmount!,
      yieldUnit: _yieldUnit!.trim(),
      sellingPrice: _sellingPrice!,
      priceUnit: _priceUnit!.trim(),
      totalIncome: totalIncome,
      saleDate: _saleDate!,
      notes: notes!,
    );
  }

  void clearIncomeForm() {
    _yieldAmount = 0;
    _yieldUnit = 'kg';
    _sellingPrice = 0;
    _priceUnit = 'kg';
    _saleDate = null;
    _incomeNotes = '';
  }

  bool get isExpenseFormValid =>
      _expenseCategory.isNotEmpty && _expenseAmount > 0 && _expenseDate != null;

  bool get isIncomeFormValid => _yieldAmount > 0 && _sellingPrice > 0 && _saleDate != null;

  /* --------------------------------------------------
   * FETCH APIS
   * -------------------------------------------------- */

  void createRecord(BuildContext context, Plots selectedPlot, String userId, String fieldId,
      String cropHistoryId) async {
    try {
      final payload = {"userId": userId, "feildId": fieldId, "cropHistoryId": cropHistoryId};
      final res = await _repo.createExpenseRecord(payload);
      if (res["success"]) {
        selectedPlot.kharchaKamaiRecord = true;
        kamai = KharchaKamaiModel.fromJson(res["data"]);
      }
    } catch (error) {
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  Future<void> fetchExpenseIncome(
    BuildContext context,
    String fieldId,
    String cropHistoryId,
  ) async {
    _setLoader('list', true);
    try {
      final res = await _repo.getCropBasedExpenseIncomeData(
        fieldId,
        cropHistoryId,
      );
      if (res["success"]) {
        kamai = KharchaKamaiModel.fromJson(res["data"]);
      }
      _expenses
        ..clear()
        ..addAll(kamai!.expenditures);

      _incomes
        ..clear()
        ..addAll(kamai!.incomeRecords);
    } catch (error) {
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    } finally {
      _setLoader('list', false);
    }
  }

  /* --------------------------------------------------
   * EXPENSE (OPTIMISTIC)
   * -------------------------------------------------- */

  Future<void> addExpense(
    BuildContext context,
    String recordId,
    ExpenseModel expense,
  ) async {
    // optimistic update
    _expenses.insert(0, expense);
    notifyListeners();

    _setLoader('expense', true);
    try {
      await _repo.addExpenditure(recordId, expense.toPayload());
    } catch (error) {
      // rollback if needed
      _expenses.remove(expense);
      notifyListeners();
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    } finally {
      _setLoader('expense', false);
    }
  }

  Future<void> updateExpense(
    BuildContext context,
    String recordId,
    String expenseId,
    ExpenseModel updated,
  ) async {
    final index = _expenses.indexWhere((e) => e.id == expenseId);
    if (index == -1) return;

    final old = _expenses[index];
    _expenses[index] = updated;
    notifyListeners();

    try {
      await _repo.updateExpenditure(
        recordId,
        expenseId,
        updated.toPayload(),
      );
    } catch (error) {
      _expenses[index] = old;
      notifyListeners();
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  Future<void> deleteExpense(
    BuildContext context,
    ExpenseModel expense,
  ) async {
    _expenses.remove(expense);
    notifyListeners();

    try {
      await _repo.deleteExpense(expense.recordId, expense.id!);
    } catch (error) {
      _expenses.add(expense);
      notifyListeners();
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  /* --------------------------------------------------
   * INCOME (OPTIMISTIC)
   * -------------------------------------------------- */

  Future<void> addIncome(
    BuildContext context,
    String recordId,
    IncomeModel income,
  ) async {
    _incomes.insert(0, income);
    notifyListeners();

    _setLoader('income', true);
    try {
      await _repo.addIncome(recordId, income.toPayload());
    } catch (error) {
      _incomes.remove(income);
      notifyListeners();
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    } finally {
      _setLoader('income', false);
    }
  }

  Future<void> updateIncome(
    BuildContext context,
    String recordId,
    String incomeId,
    IncomeModel updated,
  ) async {
    final index = _incomes.indexWhere((i) => i.id == incomeId);
    if (index == -1) return;

    final old = _incomes[index];
    _incomes[index] = updated;
    notifyListeners();

    try {
      await _repo.updateIncome(
        recordId,
        incomeId,
        updated.toPayload(),
      );
    } catch (error) {
      _incomes[index] = old;
      notifyListeners();
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  Future<void> deleteIncome(
    BuildContext context,
    IncomeModel income,
  ) async {
    _incomes.remove(income);
    notifyListeners();

    try {
      await _repo.deleteIncome(income.recordId, income.id!);
    } catch (error) {
      _incomes.add(income);
      notifyListeners();
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  Future<bool> finalSubmitKamai(BuildContext context, String recordId) async {
    try {
      _setLoader("finalSubmit", true);

      /// 1️⃣ VERIFY SUBMISSION
      final verifyRes = await _repo.verifySubmission(recordId);

      if ((verifyRes == null || verifyRes["success"] != true) && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          verifyRes?["message"] ?? "Verification failed",
          context,
        );
        return false;
      }

      final payload = {
        "confirmed": true,
      };

      final submitRes = await _repo.finalSubmit(recordId, payload);

      if (submitRes != null && submitRes["success"] == true) {
        /// update local kamai state so UI hides buttons instantly
        if (kamai != null) {
          kamai = kamai!.copyWith(isFinalSubmitted: true);
          notifyListeners();
        }
        return true;
      } else {
        if (context.mounted && kDebugMode) {
          Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            submitRes?["message"] ?? "Final submission failed",
            context,
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted && kDebugMode) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          e.toString(),
          context,
        );
      }
      return false;
    } finally {
      _setLoader("finalSubmit", false);
    }
  }

  /* --------------------------------------------------
   * CLEAR / RESET
   * -------------------------------------------------- */

  void clearExpenses() {
    _expenses.clear();
    notifyListeners();
  }

  void clearIncomes() {
    _incomes.clear();
    notifyListeners();
  }

  void reintialize() {
    clearExpenses();
    clearIncomes();
    kamai = null;
  }

  void disposeValues() {
    reintialize();
  }
}
