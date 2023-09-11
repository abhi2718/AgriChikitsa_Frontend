import 'dart:async';

import 'package:agriChikitsa/repository/AG+.repo/agPlus_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/getLocation.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/select_crop_model.dart';
import '../../../utils/utils.dart';

class AGPlusViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  Completer<GoogleMapController> controller = Completer();
  CameraPosition intialCameraPosition = const CameraPosition(
      target: LatLng(28.45038087587045, 77.28519398730188), zoom: 15);
  List<SelectCrop> cropList = [];
  List userPlotList = ["e", "e", "e"];
  var plotImagePath = "";
  var mapLocation = {
    "latitude": "28.45038087587045",
    "longitude": "77.28519398730188"
  };
  var selectedCrop = "";
  TextEditingController fieldNamecontroller = TextEditingController();
  String fieldName = "";
  TextEditingController fieldSizecontroller = TextEditingController();
  String fieldSize = "";
  String location = "Location Name:";
  bool imageLoader = false;
  final plotSizeFocusNode = FocusNode();
  void reinitialize() {
    imageLoader = false;
    selectedCrop = "";
    resetLocation();
    userPlotList = [];
  }

  void resetLocation() {
    intialCameraPosition = CameraPosition(
        target: LatLng(28.45038087587045, 77.28519398730188), zoom: 15);
    mapLocation = {
      "latitude": "28.45038087587045",
      "longitude": "77.28519398730188"
    };
    location = "Location Name:";
  }

  setImageLoader(value) {
    imageLoader = value;
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) => print(value))
        .onError((error, stackTrace) => print(error.toString()));
    return await Geolocator.getCurrentPosition();
  }

  moveToCurrentLocation() {
    getCurrentLocation().then((value) async {
      mapLocation["latitude"] = value.latitude.toString();
      mapLocation["longitude"] = value.longitude.toString();
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 15);
      GoogleMapController mapController = await controller.future;
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      notifyListeners();
    });
  }

  void setMapLocation(CameraPosition cameraPosition) {
    mapLocation["latitude"] = cameraPosition.target.latitude.toString();
    mapLocation["longitude"] = cameraPosition.target.longitude.toString();
  }

  void shwowLocationName() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(mapLocation["latitude"]!),
        double.parse(mapLocation["longitude"]!));
    location =
        "${placemarks.first.administrativeArea}, ${placemarks.first.street}";
    notifyListeners();
  }

  void getCropList(BuildContext context) async {
    // setJankariSubCategoryLoaderPost(true);
    try {
      cropList.clear();
      var tempList = [
        SelectCrop(name: "Garlic", backgroundImage: ""),
        SelectCrop(name: "Mustard", backgroundImage: ""),
        SelectCrop(name: "Wheat", backgroundImage: ""),
        SelectCrop(name: "Rice", backgroundImage: ""),
        SelectCrop(name: "Onion", backgroundImage: ""),
      ];
      cropList.addAll(tempList);
      // final data = await _jankariRepository.getJankariSubCategoryPost(selectedSubCategory);
      // jankariSubcategoryPostList = mapJankariSubCategoryPost(data['posts']);
      // setJankariSubCategoryLoaderPost(false);
      // notifyListeners();
    } catch (error) {
      // setJankariSubCategoryLoaderPost(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  List<SelectCrop> mapCropList(dynamic crops) {
    return List<SelectCrop>.from(crops.map((crop) {
      return SelectCrop.fromJson(crop);
    }));
  }

  void setSelectedCrop(BuildContext context, SelectCrop cropItem) {
    if (cropItem.isSelected) {
      cropItem.isSelected = false;
      selectedCrop = "";
    } else {
      cropItem.isSelected = true;
      selectedCrop = cropItem.name;
      for (final crop in cropList) {
        if (crop != cropItem) {
          crop.isSelected = false;
        }
      }
    }
    notifyListeners();
  }

  void getFields(BuildContext context) async {
    try {
      final data = await _agPlusRepository.getFields();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void createPlot(BuildContext context) async {
    try {
      final payload = {
        "feildName": fieldName,
        "cropName": selectedCrop,
        "cropImage": plotImagePath,
        "cordinates": mapLocation,
        "area": location
      };
      final data = await _agPlusRepository.createPlot(payload);
      print(data);
    } catch (error) {
      // setImageLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void setFieldName() {
    fieldName = fieldNamecontroller.text.toString();
  }

  void validateFieldName(BuildContext context) {
    if (fieldNamecontroller.text.isEmpty) {
      Utils.flushBarErrorMessage(
          "Alert", "Please Add Field Name details", context);
    } else {
      FocusScope.of(context).requestFocus(plotSizeFocusNode);
    }
  }

  void setFieldSize() {
    fieldSize = fieldSizecontroller.text.toString();
  }

  void validateFieldSize(BuildContext context) {
    if (fieldSizecontroller.text.isEmpty) {
      Utils.flushBarErrorMessage(
          "Alert", "Please Add Field Size details", context);
    } else {
      checkPlotDetails(context);
    }
  }

  void checkPlotDetails(BuildContext context) {
    fieldName = fieldNamecontroller.text.toString();
    fieldSize = fieldSizecontroller.text.toString();
    if (fieldName.isEmpty || fieldSize.isEmpty) {
      Utils.flushBarErrorMessage(
          "Alert", "Please Complete all details", context);
    } else {
      createPlot(context);
      FocusScope.of(context).unfocus();
    }
  }

  void uploadImage(context) async {
    setImageLoader(true);
    try {
      final imageFile = await Utils.capturePhoto();
      if (imageFile != null) {
        final data = await Utils.uploadImage(imageFile);
        if (data != null) setImageLoader(false);
        plotImagePath = data["imgurl"];
        Utils.model(context, GetLocation());
      }
      notifyListeners();
    } catch (error) {
      setImageLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }
}
