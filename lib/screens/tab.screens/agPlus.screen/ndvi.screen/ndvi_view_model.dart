import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/ndvi_model.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NDVIViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  bool responseLoader = true;
  NDVIResponse? ndviResponse;

  void reinitialize() {
    responseLoader = true;
    ndviResponse = null;
  }

  setReponseLoader(value) {
    responseLoader = value;
    notifyListeners();
  }

  Future<bool> addFieldForMonitoring(BuildContext context, String fieldId) async {
    try {
      await _agPlusRepository.addFieldForMonitoring(fieldId);
      return true;
    } catch (error) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
      return false;
    }
  }

  Future<bool> getCropHealthStatus(BuildContext context, String ndviId, String pageNo) async {
    try {
      final response = await _agPlusRepository.getNDVIData(ndviId, pageNo);
      print(response);
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
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context,
          );
        }
      }
    }
    return false;
  }
}
