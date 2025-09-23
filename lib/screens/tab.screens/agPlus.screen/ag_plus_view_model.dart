import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/pestAndDisease.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/model/weed_protection.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/add_field_status_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/crop.helpers/change_crop_duration.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/crop_details.dart';
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
  dynamic sowingDate;
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
  bool notPlantedCheck = false;
  bool infoRequestRaised = false;
  late SelectCrop? selectedChangeCrop;
  final plotSizeFocusNode = FocusNode();

  //Variables for crop change
  bool changeCropLoader = false;

  //Below variable are for reports
  final List<dynamic> reportsList = [];
  int currentReportsPage = 1;
  int totalReportsPages = 1;
  bool isReportsLoading = false;

  //check crop if available in state
  bool cropStateAvailabilityLoader = false;

  //Variables for weed protection section
  // late WeedProtection? weedProtection;
  WeedProtection weedProtection = WeedProtection(organic: [], chemical: []);
  bool isWeedDataLoading = false;

  //Variable for pest disease section
  PestDiseaseData pestDiseaseData = PestDiseaseData(pests: [], diseases: []);
  bool isPestDataLoading = false;

  //Location Variables
  bool isLocationEnabled = false;
  bool checkLocationLoader = false;

  //Add Sowing Date
  bool sowingDateLoader = false;

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
    notPlantedCheck = false;
    reportsList.clear();
    currentReportsPage = 1;
    totalReportsPages = 1;
    isReportsLoading = false;
    cropStateAvailabilityLoader = false;
    weedProtection = WeedProtection(organic: [], chemical: []);
    pestDiseaseData = PestDiseaseData(pests: [], diseases: []);
    isWeedDataLoading = false;
    isPestDataLoading = false;
    changeCropLoader = false;
    checkLocationLoader = false;
    sowingDateLoader = false;
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
    notPlantedCheck = false;
    fieldNamecontroller.clear();
    varietyNameController.clear();
    fieldSizecontroller.clear();
    reportsList.clear();
    currentReportsPage = 1;
    totalReportsPages = 1;
    isReportsLoading = false;
    cropStateAvailabilityLoader = false;
    isWeedDataLoading = false;
    isPestDataLoading = false;
    changeCropLoader = false;
    checkLocationLoader = false;
    sowingDateLoader = false;
  }

  void disposeValues() {
    userPlotList = [];
    selectedPlot = null;
    mapLocation = {"latitude": "", "longitude": ""};
    infoRequestRaised = false;
    reinitialize();
  }

  resetReportsPage() {
    reportsList.clear();
    totalReportsPages = 1;
    isReportsLoading = false;
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

  setCropStateAvailabilityLoader(value) {
    cropStateAvailabilityLoader = value;
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
    notifyListeners();
  }

  setChangeCropLoader(value) {
    changeCropLoader = value;
    notifyListeners();
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

  setWeedProtectionLoader(value) {
    isWeedDataLoading = value;
    notifyListeners();
  }

  setPestDataLoader(value) {
    isPestDataLoading = value;
    notifyListeners();
  }

  setSowingDateLoader(value) {
    sowingDateLoader = value;
    notifyListeners();
  }

  setCheckLocationLoader(value) {
    checkLocationLoader = value;
    notifyListeners();
  }

  getUserDetails() async {
    final localStorage = await SharedPreferences.getInstance();
    final rawProfile = localStorage.getString('profile');
    final profile = jsonDecode(rawProfile!);
    phoneNumber = profile['user']['phoneNumber'].toString();
  }

  Future<bool> checkLocation(BuildContext context) async {
    setCheckLocationLoader(true);
    try {
      isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      setCheckLocationLoader(false);
      return true;
    } catch (error) {
      setCheckLocationLoader(false);
      if (context.mounted) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
      return false;
    }
  }

  Future<Position> getCurrentLocation() async {
    setFieldImageLoader(true);
    await Geolocator.requestPermission();
    setFieldImageLoader(true);
    return await Geolocator.getCurrentPosition();
  }

  mapCurrentLocation(context) {
    getCurrentLocation().then((value) {
      if (!context.mounted) return;
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
      setNotPlantedCheck(false);
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
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
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
      Map<String, dynamic>? res;
      if (sowingDate != null) {
        res = await _agPlusRepository
            .checkCropAvailablity(selectedCropId, {"sowingMonth": sowingDate.month.toString()});
        if (!res!["status"]) {
          if (context.mounted) {
            Utils.flushBarErrorMessage(
                AppLocalization.of(context).getTranslatedValue("alert").toString(),
                AppLocalization.of(context).locale.toString() == "en"
                    ? res["message_en"].toString()
                    : res["message_hi"].toString(),
                context);
          }
          return;
        }
      }
      final payload = {
        "feildName": fieldName,
        "cropId": selectedCropId,
        "cropImage": plotImagePath,
        "cordinates": mapLocation,
        "area": "$fieldSize $areaUnit",
        "soilType": soilType,
        "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        "sowingSeason": res != null ? res["season"] : null,
        if (selectedDuration != null) "durationId": selectedDuration["_id"],
        if (varietyName.isNotEmpty) "variety": varietyName,
      };
      final data = await _agPlusRepository.createPlot(payload);
      if (data['message'] == "Data added Successfully") {
        Plots newPlot = Plots(
          id: data['data']['_id'],
          fieldNo: (userPlotList.length + 1).toString(),
          fieldName: fieldName,
          cropId: selectedCropId,
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
        if (context.mounted) {
          addPlotStatus(context);
        }
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
      if (context.mounted) {
        addPlotStatus(context);
      }
      Timer(const Duration(seconds: 3), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
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
      if (!context.mounted) return;
      final imageFile = await Utils.capturePhoto();
      if (imageFile != null) {
        final data = await Utils.uploadImage(imageFile);
        plotImagePath = data["imgurl"];
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

  Future<bool> checkPremium(BuildContext context) async {
    try {
      final res = await _agPlusRepository.checkPremium();
      if (!res["isPremiumUser"]) {
        if (context.mounted) {
          Utils.toastMessage(
              AppLocalization.of(context).getTranslatedValue("premiumWarningMessage").toString());
        }
        return false;
      }
      return true;
    } catch (error) {
      if (context.mounted) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
      return false;
    }
  }

  //Below Methods are for Soil Testing Feature
  setReportsLoader(bool value) {
    isReportsLoading = value;
    // notifyListeners();
  }

  void getSoilReportsList(BuildContext context, String fieldId, int pageNo) async {
    resetReportsPage();
    try {
      setReportsLoader(true);
      final response = await _agPlusRepository.getReportsList(fieldId, pageNo);
      final data = response["data"];
      reportsList.addAll(data);
      currentReportsPage = response['page'];
      totalReportsPages = response['pages'];
      setReportsLoader(false);
      notifyListeners();
    } catch (error) {
      setReportsLoader(false);
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

  void raiseRequest(BuildContext context, String fieldId) async {
    setRequestLoader(true);
    try {
      final localStorage = await SharedPreferences.getInstance();
      final mapString = localStorage.getString('profile');
      final profile = jsonDecode(mapString!);
      if (profile['user'] != null) {
        final payload = {
          "name": profile['user']['name'],
          "phoneNumber": phoneNumber,
          "requestSource": "Ag_app",
          "village": profile['user']['village'],
          "district": profile['user']['district_en'],
          "irrigationMode": "Drip",
          "block": "Central",
          "cropName": selectedPlot.cropName,
          "fieldId": fieldId
        };
        requestStatus = false;
        await _agPlusRepository.raiseSoilTestingRequest(payload);
        requestStatus = true;
      } else {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
              AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
              context);
        }
      }
      setRequestLoader(false);
    } catch (error) {
      requestStatus = false;
      setRequestLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
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
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
      return true;
    }
  }

  void checkCropAvailability(
      BuildContext context, String cropId, bool isFromFieldScreen, String fieldId) async {
    setCropStateAvailabilityLoader(true);
    try {
      final res = await _agPlusRepository.checkCropAvailablity(cropId, {});
      if (res["status"]) {
        if (isFromFieldScreen) {
          Navigator.pop(context);
          Utils.model(
              context,
              ChangeCropDuration(
                fieldId: fieldId,
              ));
        } else {
          Navigator.pop(context);
          Utils.model(context, const CropDetails());
        }
      } else {
        Utils.toastMessage(
            AppLocalization.of(context).getTranslatedValue("cropNotAvailableInState").toString());
      }
      setCropStateAvailabilityLoader(false);
    } catch (error) {
      setCropStateAvailabilityLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  //---------------------------------------------------------------------------
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

  void reinitalizeAfterCropChange() {
    fieldName = '';
    fieldSize = '';
    areaUnit = '';
    fieldNamecontroller.clear();
    fieldSizecontroller.clear();
    sowingDate = null;
    notPlantedCheck = false;
    varietyName = '';
    selectedChangeCrop = null;
    notifyListeners();
  }

  void changeCropFromField(BuildContext context, String fieldId) async {
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
    setChangeCropLoader(true);
    try {
      Map<String, dynamic>? res;
      if (sowingDate != null) {
        res = await _agPlusRepository
            .checkCropAvailablity(selectedCropId, {"sowingMonth": sowingDate.month.toString()});
        if (!res?["status"]) {
          if (context.mounted) {
            Utils.flushBarErrorMessage(
                AppLocalization.of(context).getTranslatedValue("alert").toString(),
                AppLocalization.of(context).locale.toString() == "en"
                    ? res!["message_en"].toString()
                    : res!["message_hi"].toString(),
                context);
            setChangeCropLoader(false);
            return;
          }
        }
      }
      final payload = {
        'cropId': selectedChangeCrop!.id,
        'cropImage': selectedChangeCrop!.backgroundImage,
        'feildId': fieldId,
        "area": "$fieldSize $areaUnit",
        "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        "sowingSeason": res != null ? res["season"] : null,
        if (selectedDuration != null) "durationId": selectedDuration["_id"],
        if (varietyName.isNotEmpty) "verity": varietyName,
      };
      await _agPlusRepository.changeCrop(payload);
      selectedPlot.cropId = selectedChangeCrop!.id;
      selectedPlot.cropName = selectedChangeCrop!.name;
      selectedPlot.cropNameHi = selectedChangeCrop!.name_hi;
      selectedPlot.isMonitoringOpted = false;
      selectedPlot.area = "$fieldSize $areaUnit";
      selectedPlot.ndviId = null;
      selectedPlot.sowingDate =
          sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null;
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
      reinitalizeAfterCropChange();
      unselectAllCrop();
      setChangeCropLoader(false);
    } catch (error) {
      setChangeCropLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void setSowingDateFields() {
    fieldSizecontroller.text = selectedPlot.area.split(" ")[0];
    fieldSize = fieldSizecontroller.text;
    areaUnit = selectedPlot.area.split(" ")[1];
    sowingDate = null;
    selectedCropId = selectedPlot.cropId;
    notifyListeners();
  }

  void addSowingDate(BuildContext context, String fieldId, bool isFromCropCard) async {
    fieldSize = selectedPlot.area.split(" ")[0];
    areaUnit = selectedPlot.area.split(" ")[1];
    if (fieldSize.trim().isEmpty || areaUnit.isEmpty) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("warningSelectAreaUnit").toString());
      return;
    }
    if (sowingDate == null) {
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
    setSowingDateLoader(true);
    try {
      Map<String, dynamic>? res;
      if (sowingDate != null) {
        res = await _agPlusRepository.checkCropAvailablity(
            selectedPlot.cropId, {"sowingMonth": sowingDate.month.toString()});
        if (!res?["status"]) {
          if (context.mounted) {
            Utils.flushBarErrorMessage(
                AppLocalization.of(context).getTranslatedValue("alert").toString(),
                AppLocalization.of(context).locale.toString() == "en"
                    ? res!["message_en"].toString()
                    : res!["message_hi"].toString(),
                context);
            setSowingDateLoader(false);
            return;
          }
        }
      }
      final payload = {
        "area": "$fieldSize $areaUnit",
        "soilType": selectedPlot.soilType,
        "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        "sowingSeason": res != null ? res["season"] : null,
        if (selectedDuration != null) "durationId": selectedDuration["_id"],
        if (varietyName.isNotEmpty) "verity": varietyName,
      };
      await _agPlusRepository.updateField(selectedPlot.id, payload);
      selectedPlot.isMonitoringOpted = false;
      selectedPlot.ndviId = null;
      selectedPlot.sowingDate =
          sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null;
      if (context.mounted) {
        Navigator.pop(context);
      }
      sowingDate = null;
      reinitalizeAfterCropChange();
      setSowingDateLoader(false);
    } catch (error) {
      setSowingDateLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  //Methods for kharpatwar section
  void getWeedProtectionData(BuildContext context, String cropId) async {
    setWeedProtectionLoader(true);
    try {
      final res = await _agPlusRepository.getWeedProtectionData(cropId);
      if (res != null && res is Map<String, dynamic>) {
        weedProtection = WeedProtection.fromJson({
          "organic": res["organic"] ?? [],
          "chemical": res["chemical"] ?? [],
        });
      } else {
        weedProtection = WeedProtection(organic: [], chemical: []);
      }
      setWeedProtectionLoader(false);
    } catch (error) {
      setWeedProtectionLoader(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
            AppLocalization.of(context).getTranslatedValue("errorMessage").toString(),
            context);
      }
    }
  }

  //Methods below are for Pest and Disease Section
  void getPestsDiseaseData(BuildContext context, String cropId) async {
    setPestDataLoader(true);
    try {
      final res = await _agPlusRepository.getPestAndDiseaseData(cropId);
      if (res != null) {
        pestDiseaseData = PestDiseaseData.fromJson(res[0]);
      } else {
        pestDiseaseData = PestDiseaseData(pests: [], diseases: []);
      }
      setPestDataLoader(false);
    } catch (error) {
      setPestDataLoader(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
            AppLocalization.of(context).getTranslatedValue("errorMessage").toString(),
            context);
      }
    }
  }

  //This returns localized unit value for dropdowns
  String? getLocalizedUnit(String value, BuildContext context) {
    if (value.isEmpty) return null;

    final acre = AppLocalization.of(context).getTranslatedValue("acre").toString();
    final hectare = AppLocalization.of(context).getTranslatedValue("hectare").toString();

    if (value == "एकड़" || value.toLowerCase() == "acre") {
      return acre;
    } else if (value == "हेक्टेयर" || value.toLowerCase() == "hectare") {
      return hectare;
    }

    return null; // fallback
  }
}
