import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './base_api_services.dart';
import '../app_excaptions.dart';

class NetworkApiService extends BaseApiServices {
  dynamic _jsonResponse;
  Future<Map<String, String>> getHeaders() async {
    final localStorage = await SharedPreferences.getInstance();
    final mapString = localStorage.getString('profile');
    if (mapString != null) {
      final profile = jsonDecode(mapString);
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${profile["token"]}',
      };
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  @override
  Future<dynamic> getGetApiResponse(String url) async {
    final headers = await getHeaders();
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      _jsonResponse = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection!");
    }
    return _jsonResponse;
  }

  @override
  Future getPostApiResponse(String url, dynamic payload) async {
    final headers = await getHeaders();
    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));
      _jsonResponse = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection!");
    }
    return _jsonResponse;
  }

  @override
  Future getPatchApiResponse(String url, dynamic payload) async {
    final headers = await getHeaders();
    try {
      final response = await http
          .patch(Uri.parse(url), headers: headers, body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));
      _jsonResponse = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection!");
    }
    return _jsonResponse;
  }

  @override
  Future getDeleteApiResponse(String url) async {
    final headers = await getHeaders();
    try {
      final response = await http
          .patch(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      _jsonResponse = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection!");
    }
    return _jsonResponse;
  }

  dynamic returnResponse(http.Response response) {
    final body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return body;
      case 201:
        return body;
      case 400:
        throw BadRequestException(body["message"].toString());
      case 404:
        throw UnAuthorisedException(body["message"].toString());
      default:
        throw FetchDataException(body["message"].toString());
    }
  }
}
