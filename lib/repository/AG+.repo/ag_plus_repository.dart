import 'dart:developer';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class AGPlusRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> getFields() async {
    try {
      const url = AppUrl.getFieldsEndPoint;
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCropDuration(String cropId) async {
    try {
      final url = "${AppUrl.getCropsListEndPoint}/$cropId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchCropsCategoryList() async {
    try {
      const url = AppUrl.getCropsCategoryListEndPoint;
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCropsList(String selectedCropCategory) async {
    try {
      final url = selectedCropCategory == "All"
          ? AppUrl.getCropsListEndPoint
          : "${AppUrl.getCropsListEndPoint}/?category=$selectedCropCategory";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createPlot(dynamic payload) async {
    const url = AppUrl.createPlotEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> deleteField(String fieldId) async {
    final url = '${AppUrl.deleteFieldEndPoint}/$fieldId';
    try {
      final response = await _apiServices.getPutApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> activateAgristick(String id, String fieldId) async {
    final url = '${AppUrl.activateAgriStickEndPoint}/$id/$fieldId';
    try {
      final response = await _apiServices.getPutApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getCurrentWeather(String latitude, String longitude, String lang) async {
    try {
      // final lang1 = AppLocalization.of(context).locale.toString() == "en" ? "en" : "hi";
      // log(lang1);
      final url = lang == "en"
          ? '${AppUrl.weatherAPIEndPoint}&q=$latitude,$longitude&aqi=no'
          : '${AppUrl.weatherAPIEndPoint}&q=$latitude,$longitude&aqi=no&lang=hi';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPredictedWeather(String latitude, String longitude) async {
    try {
      final url =
          'http://api.weatherapi.com/v1/forecast.json?key=94488ccb442e4337ad735838231309&q=$latitude,$longitude&aqi=no&days=3';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Old Implementation
  // Future<dynamic> getGraphData(String agriStickId, String selectedDate) async {
  //   final url = '${AppUrl.graphDataEndPoint}/$agriStickId?startDate=$selectedDate';
  //   try {
  //     final response = await _apiServices.getGetApiResponse(url);
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<dynamic> getGraphData(String selectedDate) async {
    const url = "https://api.thingspeak.com/channels/1548738/feeds.json";
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> raiseSoilTestingRequest(dynamic payload) async {
    const url = AppUrl.raiseTestingRequestEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getReportsList(String fieldId, int pageNo) async {
    final url = "${AppUrl.raiseTestingRequestEndPoint}$fieldId?page=$pageNo";
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> raiseInfoRequest(dynamic payload) async {
    const url = AppUrl.infoRequestEndpoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> changeCrop(dynamic payload) async {
    const url = AppUrl.changeCropEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> fetchPlotHistory(String fieldId) async {
    try {
      final url = "${AppUrl.cropHistoryEndpoint}/$fieldId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
