import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/chemical_solutions.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PestMedicineViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();

  ChemicalSolution? solution;
  bool isSolutionLoading = false;

  TextEditingController plotSizeController = TextEditingController();
  String plotSize = "";

  String? selectedAreaUnitValue;
  String selectedPumpSizeValue = "15";
  bool isCalculating = false;
  final List<Map<String, dynamic>> areaUnits = [
    {"id": 1, "textEn": "Acre", "textHi": "एकड़", "value": "acre"},
    {"id": 2, "textEn": "Hectare", "textHi": "हेक्टेयर", "value": "hectare"},
    {"id": 3, "textEn": "Gunta", "textHi": "गुंता", "value": "hunta"},
    {"id": 4, "textEn": "Bigha", "textHi": "बीघा", "value": "bigha"}
  ];

  final List<Map<String, dynamic>> pumpSizes = [
    {"id": 1, "textEn": "15 Liter", "textHi": "15 Liter", "value": "15"},
    {"id": 2, "textEn": "20 Liter", "textHi": "20 Liter", "value": "20"},
    {"id": 3, "textEn": "25 Liter", "textHi": "25 Liter", "value": "25"},
  ];

  void reinitialize() {
    solution = null;
    isSolutionLoading = false;
    plotSizeController.clear();
    plotSize = "";
    selectedAreaUnitValue = null;
    selectedPumpSizeValue = "15";
    isCalculating = false;
  }

  void reinitializeMedicine() {
    solution = null;
    isSolutionLoading = false;
    plotSizeController.clear();
    plotSize = "";
    selectedAreaUnitValue = null;
    selectedPumpSizeValue = "15";
    isCalculating = false;
  }

  void disposeValues() {
    solution = null;
    isSolutionLoading = false;
    plotSizeController.dispose();
    plotSize = "";
    selectedAreaUnitValue = null;
    selectedPumpSizeValue = "15";
    isCalculating = false;
  }

  void setIsCalculating(bool value) {
    isCalculating = value;
    notifyListeners();
  }

  void setSolutionDataLoader(bool value) {
    isSolutionLoading = value;
    notifyListeners();
  }

  void setPlotSize() {
    plotSize = plotSizeController.text.toString().trim();
  }

  void setSelectedAreaUnit(String value) {
    selectedAreaUnitValue = value;
    notifyListeners();
  }

  void setSelectedPumpSize(String value) {
    selectedPumpSizeValue = value;
    notifyListeners();
  }

  void validatePlotSize(BuildContext context) {
    if (plotSizeController.text.isEmpty) {
      Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("warningSelectAreaUnit").toString(),
          context);
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> getSolutionsData(
    BuildContext context,
    String solutionId,
  ) async {
    isSolutionLoading = true;
    notifyListeners();
    try {
      final res = await _agPlusRepository.getSolutionsData(solutionId);
      solution = ChemicalSolution.fromJson(res['data']);
    } catch (error) {
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    } finally {
      isSolutionLoading = false;
      notifyListeners();
    }
  }

  void toggleMedicineLike(BuildContext context, String chemicalId) async {
    try {
      await _agPlusRepository.toggleMedicineLike(chemicalId);
    } catch (error) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  void toggleMedicineDislike(BuildContext context, String chemicalId) async {
    try {
      await _agPlusRepository.toggleMedicineDislike(chemicalId);
    } catch (error) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  bool validateDosageInputs(BuildContext context) {
    if (plotSizeController.text.trim().isEmpty) {
      Utils.flushBarErrorMessage(
        AppLocalization.of(context).getTranslatedValue("alert").toString(),
        AppLocalization.of(context).getTranslatedValue("warningEnterSoilType").toString(),
        context,
      );
      return false;
    }

    if (selectedAreaUnitValue == null) {
      Utils.flushBarErrorMessage(
        AppLocalization.of(context).getTranslatedValue("alert").toString(),
        AppLocalization.of(context).getTranslatedValue("warningSizeDescription").toString(),
        context,
      );
      return false;
    }

    return true;
  }

  Future<dynamic> calculateDosage(BuildContext context, String chemicalId) async {
    setIsCalculating(true);
    try {
      final payload = {
        "area": int.parse(plotSize.toString()),
        "areaUnit": selectedAreaUnitValue,
        "pumpSize": int.parse(selectedPumpSizeValue.toString())
      };
      final res = await _agPlusRepository.calculatePestDosage(chemicalId, payload);
      setIsCalculating(false);
      return res;
    } catch (error) {
      setIsCalculating(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }
}
