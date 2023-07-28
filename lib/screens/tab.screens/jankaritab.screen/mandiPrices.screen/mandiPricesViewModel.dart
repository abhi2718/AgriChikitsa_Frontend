import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../repository/mandiPrices.repo/mandiPrices_tab_repository.dart';
import '../../../../routes/routes_name.dart';
import '../../../../utils/utils.dart';

class MandiPricesModel with ChangeNotifier {
  final _mandiPricesRepository = MandiPricesTabRepository();
  dynamic stateList = [];
  dynamic districtList = [];
  dynamic marketList = [];
  dynamic cropList = [];
  bool stateLoading = false;
  var selectedState = "";
  var selectedDistrict = "";
  var selectedMarket = "";
  var selectedCommodity = "";

  setStateLoading(value) {
    stateLoading = value;
  }

  void reinitalize() {
    districtList = [];
    marketList = [];
    cropList = [];
    selectedState = "";
    selectedMarket = "";
    selectedDistrict = "";
    selectedCommodity = "";
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void setSelectedState(String value) {
    selectedState = value;
    notifyListeners();
  }

  void setSelectedDistrict(String value) {
    selectedDistrict = value;
    notifyListeners();
  }

  void setSelectedMarket(String value) {
    selectedMarket = value;
    notifyListeners();
  }

  void setSelectedCommodity(String value) {
    selectedCommodity = value;
    notifyListeners();
  }

  void fetchStates(BuildContext context) async {
    setStateLoading(true);
    try {
      final data = await _mandiPricesRepository.fetchStates();
      stateList = data["states"].cast<String>();
      setStateLoading(false);
      notifyListeners();
    } catch (error) {
      setStateLoading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage("Error", error.toString(), context);
      }
    }
  }

  void fetchDistrict(BuildContext context) async {
    try {
      selectedDistrict = "";
      selectedMarket = "";
      selectedCommodity = "";
      districtList.clear();
      marketList.clear();
      cropList.clear();
      final data = await _mandiPricesRepository.fetchDistricts(selectedState);
      districtList = data["districts"].cast<String>();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage("Error", error.toString(), context);
      }
    }
  }

  void fetchMarket(BuildContext context) async {
    try {
      selectedMarket = "";
      selectedCommodity = "";
      marketList.clear();
      cropList.clear();
      final data = await _mandiPricesRepository.fetchMarkets(selectedDistrict);
      marketList = data["markets"].cast<String>();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage("Error", error.toString(), context);
      }
    }
  }

  void fetchCommodities(BuildContext context) async {
    try {
      final data =
          await _mandiPricesRepository.fetchCommodities(selectedMarket);
      cropList = data["comodities"].cast<String>();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage("Error", error.toString(), context);
      }
    }
  }

  Future<dynamic> fetchPrices(BuildContext context) async {
    try {
      final data = await _mandiPricesRepository.fetchPrices(
          selectedState, selectedDistrict, selectedMarket, selectedCommodity);
      return data;
    } catch (error) {
      Utils.flushBarErrorMessage("Error", error.toString(), context);
    }
  }
}
