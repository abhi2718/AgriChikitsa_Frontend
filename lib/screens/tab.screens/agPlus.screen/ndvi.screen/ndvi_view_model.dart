import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/ndvi_model.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';

class NDVIViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  bool responseLoader = true;
  bool addForMonitoringLoader = false;
  NDVIResponse? ndviResponse;

  void reinitialize() {
    responseLoader = true;
    ndviResponse = null;
    addForMonitoringLoader = false;
  }

  void setReponseLoader(bool value) {
    responseLoader = value;
    notifyListeners();
  }

  void setAddForMonitoringLoader(bool value) {
    addForMonitoringLoader = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> addFieldForMonitoring(BuildContext context, String fieldId) async {
    setAddForMonitoringLoader(true);
    try {
      final res = await _agPlusRepository.addFieldForMonitoring(fieldId);
      setAddForMonitoringLoader(false);
      return {...res, "success": true};
    } catch (error) {
      setAddForMonitoringLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            Utils.getBackendErrorMessage(error, context),
            context);
      }
      return {"success": false};
    }
  }

  Future<bool> getCropHealthStatus(BuildContext context, String ndviId, String pageNo) async {
    try {
      final response = await _agPlusRepository.getNDVIData(ndviId, pageNo);
      if (response is List && response.length >= 2) {
        final data = response[0] as Map<String, dynamic>?;
        final statusCode = response[1] as int?;

        if (data != null && statusCode != null) {
          ndviResponse = NDVIResponse.fromJson(data, statusCode);
          setReponseLoader(false);
          return true;
        }
      }
    } catch (error) {
      setReponseLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          Utils.getBackendErrorMessage(error, context),
          context,
        );
      }
    }
    return false;
  }
}
