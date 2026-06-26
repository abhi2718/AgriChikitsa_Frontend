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
  bool _updateLoader = false;

  bool get expenseLoader => _expenseLoader;
  bool get incomeLoader => _incomeLoader;
  bool get listLoader => _listLoader;
  bool get finalSubmitLoader => _finalSubmitLoader;
  bool get updateLoader => _updateLoader;

  void _setLoader(String type, bool value) {
    if (type == 'expense') _expenseLoader = value;
    if (type == 'income') _incomeLoader = value;
    if (type == 'list') _listLoader = value;
    if (type == 'finalSubmit') _finalSubmitLoader = value;
    if (type == 'updateLoader') _updateLoader = value;
    notifyListeners();
  }

  /* --------------------------------------------------
   * STATE ARRAYS (SOURCE OF TRUTH FOR UI)
   * -------------------------------------------------- */
  KharchaKamaiModel? kamai;
  final List<ExpenseModel> _expenses = [];
  final List<IncomeModel> _incomes = [];

  List<CropProfitModel> cropProfits = [];
  int currentPage = 1;
  int totalPages = 1;
  bool profitLoader = false;

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
  double? quantity;
  String? unit;

  String get expenseCategory => _expenseCategory;
  String get expenseSubCategory => _expenseSubCategory;
  double get expenseAmount => _expenseAmount;
  DateTime? get expenseDate => _expenseDate;
  String get expenseDescription => _expenseDescription;

  void setExpenseCategory(String value) {
    _expenseCategory = value;
    unit = null;
    quantity = null;
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

  void setQuantity(double val) {
    quantity = val;
    notifyListeners();
  }

  void setUnit(String val) {
    unit = val;
    notifyListeners();
  }

  ExpenseModel? buildExpenseFromForm(BuildContext context) {
    final isEnglish = AppLocalization.of(context).locale.toString() == "en";

    if (_expenseCategory.trim().isEmpty) {
      Utils.toastMessage(isEnglish ? "Please select expense category" : "कृपया खर्च श्रेणी चुनें");
      return null;
    }

    if (_expenseSubCategory.trim().isEmpty) {
      Utils.toastMessage(isEnglish ? "Please enter sub category" : "कृपया उप-श्रेणी दर्ज करें");
      return null;
    }

    if (quantity == null ||
        quantity!.toString().trim().isEmpty ||
        unit == null ||
        unit!.trim().isEmpty) {
      Utils.toastMessage(
          isEnglish ? "Please enter quantity and unit" : "कृपया मात्रा और इकाई दर्ज करें");
      return null;
    }

    if (_expenseAmount <= 0) {
      Utils.toastMessage(
          isEnglish ? "Please enter valid expense amount" : "कृपया मान्य खर्च राशि दर्ज करें");
      return null;
    }

    if (_expenseDate == null) {
      Utils.toastMessage(isEnglish ? "Please select expense date" : "कृपया खर्च की तारीख चुनें");
      return null;
    }

    // description is optional → trim only
    final description = _expenseDescription == null ? null : _expenseDescription!.trim();
    return ExpenseModel(
      recordId: "",
      category: _expenseCategory.trim(),
      subCategory: _expenseSubCategory.trim(),
      amount: _expenseAmount,
      quantity: quantity!,
      unit: unit!.trim(),
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
    quantity = null;
    unit = null;
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
    _priceUnit = value;
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

  IncomeModel? buildIncomeFromForm(BuildContext context) {
    final isEnglish = AppLocalization.of(context).locale.toString() == "en";
    // yield amount
    if (_yieldAmount <= 0) {
      Utils.toastMessage(isEnglish
          ? "Please enter valid yield amount"
          : "कृपया मान्य उत्पादन की मात्रा दर्ज करें");
      return null;
    }

    // yield unit
    if (_yieldUnit.trim().isEmpty) {
      Utils.toastMessage(isEnglish ? "Please select yield unit" : "कृपया उत्पादन इकाई चुनें");
      return null;
    }

    // selling price
    if (_sellingPrice <= 0) {
      Utils.toastMessage(
          isEnglish ? "Please enter valid selling price" : "कृपया मान्य बिक्री दर दर्ज करें");
      return null;
    }

    // price unit
    if (_priceUnit.trim().isEmpty) {
      Utils.toastMessage(isEnglish ? "Please select price unit" : "कृपया दर इकाई चुनें");
      return null;
    }

    // total income (derived but still must be valid)
    if (totalIncome <= 0) {
      Utils.toastMessage(isEnglish ? "Total income is invalid" : "कृपया मान्य आय दर्ज करें");
      return null;
    }

    // sale date
    if (_saleDate == null) {
      Utils.toastMessage(isEnglish ? "Please select sale date" : "कृपया बिक्री की तारीख चुनें");
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
        selectedPlot.kharchaKamaiRecord = res["data"]["_id"];
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
        log(res.toString());
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
    // optimistic expense list update
    _expenses.insert(0, expense);
    kamai!.expenditures.insert(0, expense);

    // ----------------------------
    // OPTIMISTIC TOTAL UPDATE
    // ----------------------------
    if (kamai != null) {
      final oldTotals = kamai!.totalExpenditures;
      final amount = expense.amount;

      double seeds = oldTotals.seeds;
      double machinery = oldTotals.machinery;
      double irrigation = oldTotals.irrigation;
      double electricity = oldTotals.electricity;
      double harvest = oldTotals.harvest;
      double fertilisers = oldTotals.fertilisers;
      double pesticides = oldTotals.pesticides;
      double labour = oldTotals.labour;
      double other = oldTotals.other;

      switch (expense.category) {
        case 'seeds':
          seeds += amount;
          break;
        case 'machinery':
          machinery += amount;
          break;
        case 'irrigation':
          irrigation += amount;
          break;
        case 'electricity':
          electricity += amount;
          break;
        case 'harvest':
          harvest += amount;
          break;
        case 'fertilisers':
          fertilisers += amount;
          break;
        case 'pesticides':
          pesticides += amount;
          break;
        case 'labour':
          labour += amount;
          break;
        default:
          other += amount;
      }

      final newGrandTotal = seeds +
          machinery +
          irrigation +
          electricity +
          harvest +
          fertilisers +
          pesticides +
          labour +
          other;

      final newTotals = TotalExpenditures(
        seeds: seeds,
        machinery: machinery,
        irrigation: irrigation,
        electricity: electricity,
        harvest: harvest,
        fertilisers: fertilisers,
        pesticides: pesticides,
        labour: labour,
        other: other,
        grandTotal: newGrandTotal,
      );

      kamai = kamai!.copyWith(
        totalExpenditures: newTotals,
      );
    }

    _setLoader('expense', true);
    try {
      final expenseRes = await _repo.addExpenditure(recordId, expense.toPayload());
      kamai!.expenditures[0].recordId = expenseRes["data"]["_id"];
      kamai!.expenditures[0].id =
          expenseRes["data"]["expenditures"][kamai!.expenditures.length - 1]["_id"];
    } catch (error) {
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

    _setLoader('updateLoader', true);

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
    } finally {
      _setLoader('updateLoader', false);
    }
  }

  Future<void> deleteExpense(
    BuildContext context,
    ExpenseModel expense,
  ) async {
    final index = _expenses.indexOf(expense);

    if (index == -1) return;

    /// remove immediately (CRITICAL FIX)
    _expenses.removeAt(index);

    /// update totals locally
    _subtractExpenseFromTotals(expense);

    notifyListeners();

    try {
      await _repo.deleteExpense(expense.recordId, expense.id!);
    } catch (error) {
      _expenses.insert(index, expense);

      _addExpenseToTotals(expense);

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
      BuildContext context, String recordId, IncomeModel income, Plots selectedPlot) async {
    _incomes.insert(0, income);
    kamai!.incomeRecords.insert(0, income);
    kamai!.totalIncome += income.totalIncome;
    kamai!.netProfit += income.totalIncome;
    selectedPlot.isYieldAdded = true;
    _setLoader('income', true);
    try {
      final incomeRes = await _repo.addIncome(recordId, income.toPayload());
      kamai!.incomeRecords[0].recordId = incomeRes["data"]["_id"];
      kamai!.incomeRecords[0].id =
          incomeRes["data"]["incomeRecords"][kamai!.incomeRecords.length - 1]["_id"];
    } catch (error) {
      _incomes.remove(income);
      selectedPlot.isYieldAdded = false;
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
    Plots selectedPlot,
  ) async {
    final index = _incomes.indexOf(income);

    if (index == -1) return;

    _incomes.removeAt(index);

    kamai!.totalIncome -= income.totalIncome;
    kamai!.incomeRecords.clear();
    selectedPlot.isYieldAdded = false;
    _recalculateProfit();

    notifyListeners();
    try {
      await _repo.deleteIncome(income.recordId, income.id!);
    } catch (error) {
      _incomes.insert(index, income);

      kamai!.totalIncome += income.totalIncome;
      selectedPlot.isYieldAdded = true;
      _recalculateProfit();

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

  Future<void> getProfitBreakdownByField(
    BuildContext context,
    String fieldId, {
    int page = 1,
  }) async {
    profitLoader = true;
    notifyListeners();

    try {
      final res = await _repo.getProfitBreakdownByField(fieldId, page);
      final cropsJson = res['data']?['crops'] as List<dynamic>?;
      cropProfits = cropsJson?.map((e) => CropProfitModel.fromJson(e)).toList() ?? [];
      currentPage = res["currentPage"];
      totalPages = res["totalPages"];
    } catch (error) {
      if (context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }

    profitLoader = false;
    notifyListeners();
  }

  void _addExpenseToTotals(ExpenseModel expense) {
    final totals = kamai!.totalExpenditures;

    switch (expense.category) {
      case "seeds":
        totals.seeds += expense.amount;
        break;

      case "machinery":
        totals.machinery += expense.amount;
        break;

      case "irrigation":
        totals.irrigation += expense.amount;
        break;

      case "electricity":
        totals.electricity += expense.amount;
        break;

      case "harvest":
        totals.harvest += expense.amount;
        break;

      case "fertilisers":
        totals.fertilisers += expense.amount;
        break;

      case "pesticides":
        totals.pesticides += expense.amount;
        break;

      case "labour":
        totals.labour += expense.amount;
        break;

      default:
        totals.other += expense.amount;
    }

    totals.grandTotal += expense.amount;

    _recalculateProfit();
  }

  void _subtractExpenseFromTotals(ExpenseModel expense) {
    final totals = kamai!.totalExpenditures;

    switch (expense.category) {
      case "seeds":
        totals.seeds -= expense.amount;
        break;

      case "machinery":
        totals.machinery -= expense.amount;
        break;

      case "irrigation":
        totals.irrigation -= expense.amount;
        break;

      case "electricity":
        totals.electricity -= expense.amount;
        break;

      case "harvest":
        totals.harvest -= expense.amount;
        break;

      case "fertilisers":
        totals.fertilisers -= expense.amount;
        break;

      case "pesticides":
        totals.pesticides -= expense.amount;
        break;

      case "labour":
        totals.labour -= expense.amount;
        break;

      default:
        totals.other -= expense.amount;
    }

    totals.grandTotal -= expense.amount;

    _recalculateProfit();
  }

  void _recalculateProfit() {
    kamai!.netProfit = kamai!.totalIncome - kamai!.totalExpenditures.grandTotal;
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
    cropProfits.clear();
    currentPage = 1;
    totalPages = 1;
    profitLoader = false;
    kamai = null;
  }

  void disposeValues() {
    reintialize();
  }
}
