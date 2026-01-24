import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class ExpenseTrackerRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> createExpenseRecord(dynamic payload) async {
    try {
      final url = '${AppUrl.kharchaKamaiEnpoint}/create';
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCropHistoryData(String fieldId) async {
    try {
      final url = "${AppUrl.cropHistoryEndpoint}/$fieldId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCropBasedExpenseIncomeData(String fieldId, String cropHistoryId) async {
    try {
      final url = "${AppUrl.kharchaKamaiEnpoint}/feild/$fieldId/crop/$cropHistoryId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Expense APIS
  Future<dynamic> addExpenditure(String recordId, dynamic payload) async {
    try {
      final url = '${AppUrl.kharchaKamaiEnpoint}/$recordId/expenditure';
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateExpenditure(String recordId, String expenseId, dynamic payload) async {
    try {
      final url = "${AppUrl.kharchaKamaiEnpoint}/$recordId/expenditure/$expenseId";
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteExpense(String recordId, String expenseId) async {
    final url = '${AppUrl.kharchaKamaiEnpoint}/$recordId/expenditure/$expenseId';
    try {
      final response = await _apiServices.getDeleteApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  //Income Apis
  Future<dynamic> addIncome(String recordId, dynamic payload) async {
    try {
      final url = '${AppUrl.kharchaKamaiEnpoint}/$recordId/income';
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateIncome(String recordId, String incomeId, dynamic payload) async {
    try {
      final url = "${AppUrl.kharchaKamaiEnpoint}/$recordId/income/$incomeId";
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteIncome(String recordId, String incomeId) async {
    final url = '${AppUrl.kharchaKamaiEnpoint}/$recordId/income/$incomeId';
    try {
      final response = await _apiServices.getDeleteApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
