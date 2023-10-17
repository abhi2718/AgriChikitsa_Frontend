import 'dart:async';

import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/repository/AG+.repo/agPlus_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/getLocation.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/helper/addFieldStatusScreen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/select_crop_model.dart';
import '../../../utils/utils.dart';
import 'widgets/selectCrop.dart';

class AGPlusViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  Completer<GoogleMapController> controller = Completer();
  CameraPosition intialCameraPosition =
      const CameraPosition(target: LatLng(28.45038087587045, 77.28519398730188), zoom: 15);
  List<SelectCrop> cropList = [];
  List userPlotList = [];
  dynamic selectedPlot;
  var plotImagePath = "";
  var mapLocation = {"latitude": "28.45038087587045", "longitude": "77.28519398730188"};
  var selectedCrop = "";
  TextEditingController fieldNamecontroller = TextEditingController();
  String fieldName = "";
  TextEditingController fieldSizecontroller = TextEditingController();
  String fieldSize = "";
  String location = "जगह का नाम:";
  bool fieldImageLoader = false;
  bool getFieldLoader = false;
  bool addFieldLoader = false;
  bool getCropListLoader = false;
  int currentSelectTab = 0;
  late bool fieldStatus;
  final plotSizeFocusNode = FocusNode();
  void reinitialize() {
    fieldName = "";
    currentSelectTab = 0;
    fieldImageLoader = false;
    getFieldLoader = false;
    addFieldLoader = false;
    getCropListLoader = false;
    fieldStatus = false;
    selectedCrop = "";
    plotImagePath = "";
    resetLocation();
    userPlotList = [];
    cropList = [];
  }

  void resetLoader() {
    resetLocation();
    fieldName = "";
    fieldSize = "";
    plotImagePath = "";
    location = "जगह का नाम:";
    getFieldLoader = false;
    addFieldLoader = false;
    getCropListLoader = false;
    fieldImageLoader = false;
    fieldStatus = false;
    fieldNamecontroller.clear();
    fieldSizecontroller.clear();
  }

  setSelectedTab(int value) {
    if (currentSelectTab == value) {
      return;
    }
    currentSelectTab = value;
    notifyListeners();
  }

  setGetFieldLoader(value) {
    getFieldLoader = value;
  }

  setAddFieldLoader(value) {
    addFieldLoader = value;
  }

  setFieldImageLoader(value) {
    fieldImageLoader = value;
    notifyListeners();
  }

  setCropListLoader(value) {
    getCropListLoader = value;
    notifyListeners();
  }

  void resetLocation() {
    getCropListLoader = false;
    intialCameraPosition =
        CameraPosition(target: LatLng(28.45038087587045, 77.28519398730188), zoom: 15);
    mapLocation = {"latitude": "28.45038087587045", "longitude": "77.28519398730188"};
    location = "जगह का नाम:";
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
      CameraPosition cameraPosition =
          CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 15);
      GoogleMapController mapController = await controller.future;
      mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      notifyListeners();
    });
  }

  void setMapLocation(CameraPosition cameraPosition) {
    mapLocation["latitude"] = cameraPosition.target.latitude.toString();
    mapLocation["longitude"] = cameraPosition.target.longitude.toString();
  }

  void shwowLocationName() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(mapLocation["latitude"]!), double.parse(mapLocation["longitude"]!));
    location = "${placemarks.first.administrativeArea}, ${placemarks.first.street}";
    notifyListeners();
  }

  void getCropList(BuildContext context) async {
    setCropListLoader(true);
    try {
      cropList.clear();
      final data = await _agPlusRepository.getCropsList();
      cropList = mapCropList(data["crops"]);
      setCropListLoader(false);
      if (cropList.isEmpty) {
        Navigator.pop(context);
        Utils.model(context, FieldStatusScreen());
      } else {
        Navigator.pop(context);
        Utils.model(context, CropSelection());
      }
    } catch (error) {
      setCropListLoader(false);
      Navigator.pop(context);
      Utils.model(context, FieldStatusScreen());
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
      if (data.length > 0) {
        userPlotList = mapFields(data);
        userPlotList[0].isSelected = true;
        selectedPlot = userPlotList[0];
      }
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
    setAddFieldLoader(true);
    try {
      Plots newPlot = Plots(
          fieldName: fieldName,
          cropName: selectedCrop,
          cropImage: plotImagePath,
          latitude: mapLocation['latitude'].toString(),
          longitude: mapLocation['longitude'].toString(),
          agristick: null,
          area: location);
      userPlotList.insert(0, newPlot);
      setSelectedField(newPlot);
      final payload = {
        "feildName": fieldName,
        "cropName": selectedCrop,
        "cropImage": plotImagePath,
        "cordinates": mapLocation,
        "area": fieldSize
      };
      final data = await _agPlusRepository.createPlot(payload);
      if (data['message'] == "Data added Successfully") {
        userPlotList[0].id = data['data']['_id'];
        fieldStatus = true;
        setAddFieldLoader(false);
        Utils.model(context, FieldStatusScreen());
      }
    } catch (error) {
      userPlotList.removeAt(0);
      fieldStatus = false;
      setAddFieldLoader(false);
      Utils.model(context, FieldStatusScreen());
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void deleteField(BuildContext context) async {
    try {
      await _agPlusRepository.deleteField(selectedPlot.id);
      final int selectedIndex = userPlotList.indexOf(selectedPlot);
      if (selectedIndex != -1) {
        userPlotList.removeAt(selectedIndex);
        Navigator.pop(context);
        if (userPlotList.isNotEmpty) {
          userPlotList[0].isSelected = true;
          selectedPlot = userPlotList[0];
        } else {
          selectedPlot = null;
        }
      }
      notifyListeners();
    } catch (error) {
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
      Utils.flushBarErrorMessage("Alert", "Please Add Field Name details", context);
    } else {
      FocusScope.of(context).requestFocus(plotSizeFocusNode);
    }
  }

  void setFieldSize() {
    fieldSize = fieldSizecontroller.text.toString();
  }

  void validateFieldSize(BuildContext context) {
    if (fieldSizecontroller.text.isEmpty) {
      Utils.flushBarErrorMessage("Alert", "Please Add Field Size details", context);
    } else {
      checkPlotDetails(context);
    }
  }

  void checkPlotDetails(BuildContext context) {
    fieldName = fieldNamecontroller.text.toString();
    fieldSize = fieldSizecontroller.text.toString();
    if (fieldName.isEmpty || fieldSize.isEmpty) {
      Utils.flushBarErrorMessage("Alert", "Please Complete all details", context);
    } else {
      FocusScope.of(context).unfocus();
      createPlot(context);
    }
  }

  void uploadImage(context) async {
    setFieldImageLoader(true);
    try {
      final imageFile = await Utils.capturePhoto();
      if (imageFile != null) {
        final data = await Utils.uploadImage(imageFile);
        plotImagePath = data["imgurl"];
        setFieldImageLoader(false);
        Navigator.pop(context);
        Utils.model(context, GetLocation());
      } else {
        setFieldImageLoader(false);
      }
    } catch (error) {
      setFieldImageLoader(false);
      fieldStatus = false;
      Utils.model(context, FieldStatusScreen());
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }
}
