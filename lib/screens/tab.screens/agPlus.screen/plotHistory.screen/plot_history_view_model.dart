import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlotHistoryViewModel extends ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  dynamic plotHistory;
  bool getHistoryLoader = true;
  void reinitialize() {
    plotHistory = null;
    getHistoryLoader = true;
  }

  void disposeValues() {
    plotHistory = null;
    getHistoryLoader = true;
  }

  void setHistoryLoader(bool value) {
    getHistoryLoader = value;
  }

  void getPlotHistory(BuildContext context, String fieldId) async {
    setHistoryLoader(true);
    try {
      final data = await _agPlusRepository.fetchPlotHistory(fieldId);
      if (data['data'].isNotEmpty) {
        plotHistory = data['data'];
      } else {
        plotHistory = null;
      }
      setHistoryLoader(false);
      notifyListeners();
    } catch (error) {
      setHistoryLoader(false);
      notifyListeners();
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
