import 'dart:async';

import 'package:agriChikitsa/model/plots.dart';
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
  List userPlotList = [];
  dynamic selectedPlot;
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
  bool addFieldLoader = false;
  bool getFieldLoader = false;
  final plotSizeFocusNode = FocusNode();
  void reinitialize() {
    fieldName = "";
    addFieldLoader = false;
    getFieldLoader = false;
    selectedCrop = "";
    resetLocation();
    userPlotList = [];
  }

  void resetLoader() {
    resetLocation();
    fieldName = "";
    fieldSize = "";
    location = "Location Name:";
    addFieldLoader = false;
    fieldNamecontroller.clear();
    fieldSizecontroller.clear();
  }

  setGetFieldLoader(value) {
    getFieldLoader = value;
  }

  setAddFieldLoader(value) {
    addFieldLoader = value;
    notifyListeners();
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
    setAddFieldLoader(true);
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
      setAddFieldLoader(false);
    } catch (error) {
      setAddFieldLoader(false);
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
    setGetFieldLoader(true);
    try {
      final data = await _agPlusRepository.getFields();
      userPlotList = mapFields(data);
      userPlotList[0].isSelected = true;
      selectedPlot = userPlotList[0];
      setGetFieldLoader(false);
      notifyListeners();
    } catch (error) {
      setGetFieldLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  List<Plots> mapFields(dynamic fields) {
    return List<Plots>.from(fields.map((field) {
      return Plots.fromJson(field);
    }));
  }

  void createPlot(BuildContext context) async {
    try {
      userPlotList.add(Plots(
          fieldName: fieldName,
          cropName: selectedCrop,
          cropImage: plotImagePath,
          area: location));
      final payload = {
        "feildName": fieldName,
        "cropName": selectedCrop,
        "cropImage": plotImagePath,
        "cordinates": mapLocation,
        "area": location
      };
      await _agPlusRepository.createPlot(payload);
    } catch (error) {
      setAddFieldLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void setSelectedField(Plots currentSelectedPlot) {
    if (selectedPlot == currentSelectedPlot) {
    } else {
      for (final plot in userPlotList) {
        if (plot != currentSelectedPlot) {
          plot.isSelected = false;
        } else {
          plot.isSelected = true;
          selectedPlot = plot;
        }
      }
    }
    notifyListeners();
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
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void uploadImage(context) async {
    try {
      final imageFile = await Utils.capturePhoto();
      setAddFieldLoader(true);
      if (imageFile != null) {
        // Timer(Duration(seconds: 4), () {
        //   setAddFieldLoader(false);
        //   Utils.model(context, GetLocation());
        // });
        final data = await Utils.uploadImage(imageFile);
        plotImagePath = data["imgurl"];
        setAddFieldLoader(false);
        Utils.model(context, GetLocation());
      }
    } catch (error) {
      setAddFieldLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }
}
