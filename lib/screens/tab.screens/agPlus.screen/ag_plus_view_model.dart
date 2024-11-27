import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/add_field_status_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/select_crop.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/category_model.dart';
import '../../../model/select_crop_model.dart';
import '../../../utils/utils.dart';
import 'widgets/agplus_home.dart';
import 'widgets/plot_details.dart';

class AGPlusViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  List cropCategoriesList = [];
  List<SelectCrop> cropList = [];
  List userPlotList = [];
  dynamic selectedPlot;
  var plotImagePath = "";
  var mapLocation = {"latitude": "", "longitude": ""};
  late SelectCrop selectedCrop;
  var selectedCropId = '';
  TextEditingController fieldNamecontroller = TextEditingController();
  String fieldName = "";
  TextEditingController fieldSizecontroller = TextEditingController();
  String fieldSize = "";
  String soilType = "";
  String areaUnit = "";
  late dynamic sowingDate;
  late dynamic selectedDuration;
  late List<dynamic> durations;
  String varietyName = "";
  TextEditingController varietyNameController = TextEditingController();
  String phoneNumber = '';
  String currentSelectedCategory = 'All';
  bool fieldImageLoader = false;
  bool getFieldLoader = false;
  bool addFieldLoader = false;
  bool getCropListLoader = false;
  int currentSelectTab = 0;
  late bool fieldStatus;
  bool requestStatus = false;
  bool requestLoader = false;
  bool notPlantedCheck = true;
  bool infoRequestRaised = false;
  late SelectCrop? selectedChangeCrop;
  final plotSizeFocusNode = FocusNode();
  void reinitialize() {
    fieldName = "";
    varietyName = "";
    soilType = "";
    areaUnit = "";
    currentSelectTab = 0;
    fieldImageLoader = false;
    getFieldLoader = false;
    addFieldLoader = false;
    getCropListLoader = false;
    fieldStatus = false;
    selectedChangeCrop = null;
    selectedCropId = "";
    fieldSize = "";
    plotImagePath = "";
    sowingDate = null;
    durations = [];
    currentSelectedCategory = "All";
    phoneNumber = '';
    userPlotList = [];
    cropCategoriesList = [];
    cropList = [];
    requestStatus = false;
    requestLoader = false;
    notPlantedCheck = true;
  }

  void resetLoader() {
    fieldName = "";
    varietyName = "";
    soilType = "";
    areaUnit = "";
    fieldSize = "";
    sowingDate = null;
    plotImagePath = "";
    currentSelectedCategory = "All";
    getFieldLoader = false;
    addFieldLoader = false;
    getCropListLoader = false;
    fieldImageLoader = false;
    fieldStatus = false;
    requestStatus = false;
    requestLoader = false;
    notPlantedCheck = true;
    fieldNamecontroller.clear();
    varietyNameController.clear();
    fieldSizecontroller.clear();
  }

  void disposeValues() {
    userPlotList = [];
    selectedPlot = null;
    mapLocation = {"latitude": "", "longitude": ""};
    infoRequestRaised = false;
    reinitialize();
  }

  setSelectedTab(int value) {
    if (currentSelectTab == value) {
      return;
    }
    currentSelectTab = value;
    notifyListeners();
  }

  setActiveState(BuildContext context, CategoryHome category, bool value) {
    if (currentSelectedCategory == category.id) {
      return;
    }
    selectedCropId = "";
    currentSelectedCategory = category.id;
    notifyListeners();
    getCropList(context);
  }

  setGetFieldLoader(value) {
    getFieldLoader = value;
  }

  setSoilType(value) {
    soilType = value;
    notifyListeners();
  }

  setDuration(value) {
    selectedDuration = value;
    notifyListeners();
  }

  setAreaUnit(value) {
    areaUnit = value;
    notifyListeners();
  }

  setNotPlantedCheck(value) {
    if (sowingDate != null) {
      sowingDate = null;
    }
    notPlantedCheck = value;
    selectedDuration = null;
    varietyName = "";
    varietyNameController.clear();
    notifyListeners();
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

  setRequestLoader(value) {
    requestLoader = value;
    notifyListeners();
  }

  getUserDetails() async {
    final localStorage = await SharedPreferences.getInstance();
    final rawProfile = localStorage.getString('profile');
    final profile = jsonDecode(rawProfile!);
    phoneNumber = profile['user']['phoneNumber'].toString();
  }

  Future<Position> getCurrentLocation() async {
    setFieldImageLoader(true);
    await Geolocator.requestPermission();
    setFieldImageLoader(true);
    return await Geolocator.getCurrentPosition();
  }

  mapCurrentLocation(context) {
    getCurrentLocation().then((value) {
      mapLocation["latitude"] = value.latitude.toString();
      mapLocation["longitude"] = value.longitude.toString();
      uploadImage(context);
    });
  }

  void fetchCropCategories(BuildContext context) async {
    setCropListLoader(true);
    try {
      cropCategoriesList.clear();
      selectedCropId = "";
      currentSelectedCategory = "All";
      final data = await _agPlusRepository.fetchCropsCategoryList();
      cropCategoriesList = [
        CategoryHome(
          name: "All",
          nameHi: "सभी",
          id: "All",
          isActive: false,
        ),
        ...mapCategories(data)
      ];
      getCropList(context);
    } catch (error) {
      setCropListLoader(false);
      notifyListeners();
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  List<CategoryHome> mapCategories(dynamic categories) {
    return List<CategoryHome>.from(categories.map((category) {
      return CategoryHome(
        name: category['name'],
        nameHi: category['name_hi'],
        id: category['_id'],
        isActive: false,
      );
    }));
  }

  void getCropList(BuildContext context) async {
    try {
      cropList.clear();
      final data = await _agPlusRepository.getCropsList(currentSelectedCategory);
      cropList = mapCropList(data["crops"]);
      setCropListLoader(false);
    } catch (error) {
      setCropListLoader(false);
      Navigator.pop(context);
      fieldStatus = false;
      addPlotStatus(context);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
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
      selectedCropId = '';
    } else {
      cropItem.isSelected = true;
      selectedCrop = cropItem;
      selectedCropId = cropItem.id;
      for (final crop in cropList) {
        if (crop != cropItem) {
          crop.isSelected = false;
        }
      }
      setNotPlantedCheck(true);
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
      notifyListeners();
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  List<Plots> mapFields(dynamic fields) {
    return List<Plots>.from(fields.map((field) {
      return Plots.fromJson(field);
    }));
  }

  void createPlot(BuildContext context) async {
    fieldName = fieldNamecontroller.text.toString().trim();
    fieldSize = fieldSizecontroller.text.toString().trim();
    if (fieldSize.trim().isEmpty || areaUnit.isEmpty) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("warningSelectAreaUnit").toString());
      return;
    }
    if (sowingDate == null && notPlantedCheck == false) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("checkSowingDate").toString());
      return;
    }
    if (sowingDate != null && (varietyName.isEmpty)) {
      // (varietyName.isEmpty || selectedDuration == null || selectedDuration!.isEmpty)) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("warningVarietyDuration").toString());
      return;
    }
    setAddFieldLoader(true);
    try {
      final payload = {
        "feildName": fieldName,
        "cropId": selectedCropId,
        "cropImage": plotImagePath,
        "cordinates": mapLocation,
        "area": "$fieldSize $areaUnit",
        "soilType": soilType,
        "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        if (selectedDuration != null) "durationId": selectedDuration["_id"],
        if (varietyName.isNotEmpty) "variety": varietyName,
      };
      final data = await _agPlusRepository.createPlot(payload);
      if (data['message'] == "Data added Successfully") {
        Plots newPlot = Plots(
          id: data['data']['_id'],
          fieldName: fieldName,
          cropName: selectedCrop.name,
          cropNameHi: selectedCrop.name_hi,
          cropImage: plotImagePath,
          latitude: mapLocation['latitude'].toString(),
          longitude: mapLocation['longitude'].toString(),
          agristick: null,
          area: "$fieldSize $areaUnit",
          soilType: soilType,
          sowingDate: sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        );
        userPlotList.add(newPlot);
        setSelectedField(newPlot);
        fieldStatus = true;
        setAddFieldLoader(false);
        addPlotStatus(context);
        Timer(const Duration(seconds: 3), () {
          Navigator.pop(context);
          Navigator.pop(context);
          Utils.model(
              context,
              AGPlusHome(
                plotNumber: userPlotList.length,
              ));
        });
      }
    } catch (error) {
      fieldStatus = false;
      setAddFieldLoader(false);
      addPlotStatus(context);
      Timer(const Duration(seconds: 3), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void deleteField(BuildContext context) async {
    try {
      await _agPlusRepository.deleteField(selectedPlot.id);
      final int selectedIndex = userPlotList.indexOf(selectedPlot);
      if (selectedIndex != -1) {
        userPlotList.removeAt(selectedIndex);
        selectedPlot = null;
        Navigator.pop(context);
        Navigator.pop(context);
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
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
    fieldName = fieldNamecontroller.text.toString().trim();
  }

  void setVarietyName() {
    varietyName = varietyNameController.text.toString().trim();
  }

  void validateFieldName(BuildContext context) {
    if (fieldNamecontroller.text.isEmpty) {
      Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("warningEnterPlotName").toString(),
          context);
    }
  }

  void validateVarietyName(BuildContext context) {
    if (varietyNameController.text.isEmpty) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("warningVariety").toString(), context);
    }
  }

  void setFieldSize() {
    fieldSize = fieldSizecontroller.text.toString().trim();
  }

  void validateFieldSize(BuildContext context) {
    if (fieldSizecontroller.text.isEmpty) {
      Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("warningSelectAreaUnit").toString(),
          context);
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sowingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      sowingDate = picked;
      notPlantedCheck = false;
      if (context.mounted) {
        getDuration(context);
      }
    }
    notifyListeners();
  }

  void getDuration(BuildContext context) async {
    try {
      durations = [];
      varietyName = "";
      varietyNameController.clear();
      final data = await _agPlusRepository.getCropDuration(selectedCropId);
      if (data.containsKey("durations")) {
        if (data["durations"].isEmpty) {
          durations = [];
        } else if (data["durations"].length > 1) {
          durations = data["durations"];
        } else {
          selectedDuration = data["durations"][0];
        }
      }
      notifyListeners();
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

  void checkPlotDetails(BuildContext context) {
    fieldName = fieldNamecontroller.text.toString().trim();
    if (soilType.isEmpty) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("warningSelectSoilType").toString());
      return;
    }
    fetchCropCategories(context);
    Navigator.pop(context);
    Utils.model(context, const CropSelection());
  }

  void uploadImage(context) async {
    if (mapLocation["latitude"]!.isEmpty || mapLocation["longitude"]!.isEmpty) {
      Utils.toastMessage("Error!");
      return;
    }
    setFieldImageLoader(true);
    try {
      final imageFile = await Utils.capturePhoto();
      if (imageFile != null) {
        final data = await Utils.uploadImage(imageFile);
        plotImagePath = data["imgurl"];
        // plotImagePath = "testPAth";
        Navigator.pop(context);
        Utils.model(context, const PlotDetails());
        setFieldImageLoader(false);
      } else {
        setFieldImageLoader(false);
      }
    } catch (error) {
      Navigator.pop(context);
      setFieldImageLoader(false);
      fieldStatus = false;
      addPlotStatus(context);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void raiseRequest(BuildContext context, String fieldName, String fieldId) async {
    setRequestLoader(true);
    try {
      requestStatus = false;
      final payload = {'name': fieldName, 'phoneNumber': phoneNumber, 'feildId': fieldId};
      await _agPlusRepository.raiseSoilTestingRequest(payload);
      requestStatus = true;
      setRequestLoader(false);
    } catch (error) {
      requestStatus = false;
      setRequestLoader(false);
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  Future<bool> checkPremium(BuildContext context) async {
    final localStorage = await SharedPreferences.getInstance();
    final mapString = localStorage.getString('profile');
    final profile = jsonDecode(mapString!);
    if (!profile['user']['isPremiumUser']) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("premiumWarningMessage").toString());
      return false;
    }
    return true;
  }

  Future<bool> raiseInfoRequest(BuildContext context, String type) async {
    if (infoRequestRaised) {
      Utils.toastMessage("You have already raised one request!");
      return false;
    }
    try {
      final payload = {'product': type};
      await _agPlusRepository.raiseInfoRequest(payload);
      infoRequestRaised = true;
      notifyListeners();
      return true;
    } catch (error) {
      infoRequestRaised = true;
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
      return true;
    }
  }

  void setSelectedChangedCrop(BuildContext context, SelectCrop selectedCrop) {
    selectedChangeCrop = selectedCrop;
    sowingDate = null;
    setSelectedCrop(context, selectedCrop);
    notifyListeners();
  }

  void unselectAllCrop() {
    selectedCropId = '';
    for (final crop in cropList) {
      crop.isSelected = false;
    }
  }

  void changeCropFromField(BuildContext context, String fieldId) async {
    setCropListLoader(true);
    try {
      final payload = {
        'cropId': selectedChangeCrop!.id,
        'cropImage': selectedChangeCrop!.backgroundImage,
        'feildId': fieldId,
        "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        if (selectedDuration != null) "durationId": selectedDuration["_id"],
        if (varietyName.isNotEmpty) "verity": varietyName,
      };
      await _agPlusRepository.changeCrop(payload);
      selectedPlot.cropName = selectedChangeCrop!.name;
      selectedPlot.cropNameHi = selectedChangeCrop!.name_hi;
      selectedPlot.sowingDate =
          sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null;
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
      unselectAllCrop();
      setCropListLoader(false);
    } catch (error) {
      setCropListLoader(false);
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }
}
