import 'package:agriChikitsa/repository/check_prices.repo/check_prices_repository.dart';
import 'package:flutter/material.dart';

import '../../../../routes/routes_name.dart';
import '../../../../utils/utils.dart';

class CheckPricesModel with ChangeNotifier {
  final _checkPricesRepository = CheckPricesRepository();
  dynamic stateList = [
    "Punjab",
    "Himachal Pradesh",
    "Uttar Pradesh",
    "Kerala",
    "Rajasthan",
    "Nagaland",
    "Odisha",
    "Uttrakhand",
    "Telangana",
    "Gujarat",
    "Tripura",
    "Haryana",
    "Meghalaya"
  ];

  var selectedState = "";
  void goToPricesScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RouteName.pricesScreenRoute);
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void setSelectedState(String value) {
    selectedState = value;
    notifyListeners();
  }

  void fetchPrices(BuildContext context) async {
    try {
      // const state = "Uttar Pradesh";
      // final splitted = state.split(' ');
      // final data = await _checkPricesRepository.fetchPrices(
      //     "&filters%5Bstate%5D=${splitted[0]}%20${splitted[1]}&filters%5Bdistrict%5D=Auraiya&filters%5Bmarket%5D=Dibiapur&filters%5Bcommodity%5D=Pumpkin");
      // print(data["records"]);
    } catch (error) {
      Utils.flushBarErrorMessage("Error", error.toString(), context);
    }
  }
}
