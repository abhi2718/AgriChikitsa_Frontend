import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/crop_model.dart';
import 'package:agriChikitsa/model/mandi_field_model.dart';
import 'package:agriChikitsa/model/pestAndDisease.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/model/weed_protection.dart';
import 'package:agriChikitsa/repository/AG+.repo/ag_plus_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/add_field_status_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/helper/delete_field_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/medicine.screen/medicine_view_model.dart';
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
  bool _hasSeenLanding = false;
  bool get hasSeenLanding => _hasSeenLanding;

  AGPlusViewModel() {
    initHasSeenLanding();
  }

  Future<void> initHasSeenLanding() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenLanding = prefs.getBool('has_seen_agriplus_landing') ?? false;
    notifyListeners();
  }

  Future<void> setHasSeenLanding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_agriplus_landing', true);
    _hasSeenLanding = true;
    notifyListeners();
  }
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
  WeedAdvisory? selectedAdvisory;
  bool isWeedDataLoading = false;

  //Variable for pest disease section
  PestDiseaseData pestDiseaseData = PestDiseaseData(pests: [], diseases: []);
  bool isPestDataLoading = false;
  bool pestsLoaded = false;
  bool diseasesLoaded = false;
  bool isPestDetailsLoading = false;

  //Location Variables
  bool isLocationEnabled = false;
  bool checkLocationLoader = false;

  //Add Sowing Date
  bool sowingDateLoader = false;

  //Nearby Mandi Loaders
  List<NearbyMandi> nearbyMandis = [];
  bool isNearbyMandiDataLoading = false;

  //Delete Field Loader
  bool isFieldDeleting = false;

  bool isYieldDataProcessing = false;
  TextEditingController yieldController = TextEditingController();
  final List<YieldUnit> yieldUnits = [
    YieldUnit(
      value: "kg",
      labelEn: "Kg",
      labelHi: "किलोग्राम",
    ),
    YieldUnit(
      value: "quintal",
      labelEn: "Quintal",
      labelHi: "क्विंटल",
    ),
    YieldUnit(
      value: "ton",
      labelEn: "Ton",
      labelHi: "टन",
    ),
  ];
  String selectedYieldUnit = "quintal";

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
    pestsLoaded = false;
    diseasesLoaded = false;
    isWeedDataLoading = false;
    isPestDataLoading = false;
    isPestDetailsLoading = false;
    changeCropLoader = false;
    checkLocationLoader = false;
    sowingDateLoader = false;
    selectedAdvisory = null;
    nearbyMandis.clear();
    isNearbyMandiDataLoading = false;
    isYieldDataProcessing = false;
    selectedYieldUnit = "quintal";
    isFieldDeleting = false;
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
    isPestDetailsLoading = false;
    changeCropLoader = false;
    checkLocationLoader = false;
    sowingDateLoader = false;
    isNearbyMandiDataLoading = false;
    isYieldDataProcessing = false;
    yieldController.clear();
    isFieldDeleting = false;
  }

  void disposeValues() {
    userPlotList = [];
    selectedPlot = null;
    mapLocation = {"latitude": "", "longitude": ""};
    infoRequestRaised = false;
    selectedAdvisory = null;
    reinitialize();
  }

  void resetReportsPage() {
    reportsList.clear();
    totalReportsPages = 1;
    isReportsLoading = false;
  }

  void setSelectedTab(int value) {
    if (currentSelectTab == value) {
      return;
    }
    currentSelectTab = value;
    notifyListeners();
  }

  void setActiveState(BuildContext context, CategoryHome category, bool value) {
    setCropListLoader(true);
    if (currentSelectedCategory == category.id) {
      return;
    }
    selectedCropId = "";
    currentSelectedCategory = category.id;
    getCropList(context);
  }

  void setGetFieldLoader(bool value) {
    getFieldLoader = value;
  }

  void setSoilType(String value) {
    soilType = value;
    notifyListeners();
  }

  void setCropStateAvailabilityLoader(bool value) {
    cropStateAvailabilityLoader = value;
    notifyListeners();
  }

  void setDuration(dynamic value) {
    selectedDuration = value;
    notifyListeners();
  }

  void setAreaUnit(String value) {
    areaUnit = value;
    notifyListeners();
  }

  void setNotPlantedCheck(bool value) {
    if (sowingDate != null) {
      sowingDate = null;
    }
    notPlantedCheck = value;
    selectedDuration = null;
    varietyName = "";
    varietyNameController.clear();
    notifyListeners();
  }

  void setAddFieldLoader(bool value) {
    addFieldLoader = value;
    notifyListeners();
  }

  void setChangeCropLoader(bool value) {
    changeCropLoader = value;
    notifyListeners();
  }

  void setFieldImageLoader(bool value) {
    fieldImageLoader = value;
    notifyListeners();
  }

  void setCropListLoader(bool value) {
    getCropListLoader = value;
    notifyListeners();
  }

  void setRequestLoader(bool value) {
    requestLoader = value;
    notifyListeners();
  }

  void setWeedProtectionLoader(bool value) {
    isWeedDataLoading = value;
    notifyListeners();
  }

  void setPestDataLoader(bool value) {
    isPestDataLoading = value;
    notifyListeners();
  }

  void setPestDetailsLoader(bool value) {
    isPestDetailsLoading = value;
    notifyListeners();
  }

  void setSowingDateLoader(bool value) {
    sowingDateLoader = value;
    notifyListeners();
  }

  void setCheckLocationLoader(bool value) {
    checkLocationLoader = value;
    notifyListeners();
  }

  void setDeleteLoader(bool value) {
    isFieldDeleting = value;
    notifyListeners();
  }

  void getUserDetails() async {
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

  void mapCurrentLocation(BuildContext context) {
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
      if (context.mounted) {
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
      log(field.toString());
      return Plots.fromJson(field);
    }));
  }

  int getFieldNumber(List<dynamic> fields) {
    int expected = 1;

    for (final field in fields) {
      final int fieldNo = int.tryParse(field.fieldNo) ?? 0;

      if (fieldNo != expected) {
        return expected;
      }
      expected++;
    }

    return expected;
  }

  void createPlot(BuildContext context, {bool isBackPressed = false}) async {
    fieldName = fieldNamecontroller.text.toString().trim();
    fieldSize = fieldSizecontroller.text.toString().trim();
    if (!isBackPressed && (fieldSize.trim().isEmpty || areaUnit.isEmpty)) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("warningSelectAreaUnit").toString());
      return;
    }
    if (!isBackPressed && sowingDate == null && notPlantedCheck == false) {
      Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("checkSowingDate").toString());
      return;
    }
    setAddFieldLoader(true);
    try {
      Map<String, dynamic>? res;
      if (!isBackPressed && sowingDate != null) {
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
        "fieldName": fieldName,
        "fieldImage": plotImagePath,
        "cordinates": mapLocation,
        "soilType": soilType,
        if (!isBackPressed) "area": "$fieldSize $areaUnit",
        if (!isBackPressed) "cropId": selectedCropId,
        if (!isBackPressed)
          "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        if (!isBackPressed) "sowingSeason": res != null ? res["season"] : null,
        if (!isBackPressed && selectedDuration != null) "durationId": selectedDuration["_id"],
        if (!isBackPressed && varietyName.isNotEmpty) "variety": varietyName,
      };
      final data = await _agPlusRepository.createPlot(payload);
      if (data['message'] == "Data added Successfully") {
        log(data.toString());
        Plots newPlot;
        if (!isBackPressed) {
          newPlot = Plots(
              id: data['data']['fieldId'],
              fieldNo: data['data']['fieldNo'].toString(),
              fieldName: fieldName,
              cropId: selectedCropId,
              cropName: selectedCrop.name,
              cropNameHi: selectedCrop.name_hi,
              cropImage: selectedCrop.backgroundImage,
              plotImage: plotImagePath,
              latitude: mapLocation['latitude'].toString(),
              longitude: mapLocation['longitude'].toString(),
              agristick: null,
              area: "$fieldSize $areaUnit",
              soilType: soilType,
              sowingSeason: res != null ? res["season"] : null,
              sowingDate: sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
              currentStageId: data['data']['currentCropStage'] ?? "",
              cropHistoryId: data['data']['cropHistoryId'] ?? "",
              isCropCycleComplete: data['data']["isCropCycleComplete"] ?? false,
              isYieldAdded: data['data']["isYieldAdded"] ?? false,
              isHarvesting: data['data']["isHarvesting"] ?? false,
              kharchaKamaiRecord: null);
        } else {
          newPlot = Plots(
              id: data?['data']?['fieldId'] ?? "1",
              fieldNo: getFieldNumber(userPlotList).toString(),
              fieldName: fieldName,
              plotImage: plotImagePath,
              latitude: mapLocation['latitude'].toString(),
              longitude: mapLocation['longitude'].toString(),
              agristick: null,
              soilType: soilType,
              isCropCycleComplete: false,
              isYieldAdded: false,
              isHarvesting: false);
        }
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
          Utils.model(context, AGPlusHome());
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
    setDeleteLoader(true);
    try {
      await _agPlusRepository.deleteField(selectedPlot.id);
      final int selectedIndex = userPlotList.indexOf(selectedPlot);
      if (selectedIndex != -1 && context.mounted) {
        userPlotList.removeAt(selectedIndex);
        selectedPlot = null;
        Navigator.pop(context);
        Navigator.pop(context);
      }
      setDeleteLoader(false);
    } catch (error) {
      setDeleteLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            AppLocalization.of(context).getTranslatedValue("errorMessage").toString(),
            context);
      }
      if (kDebugMode && context.mounted) {
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
        final data = await Utils.uploadImage(imageFile, forPurpose: 'plot');
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
  void setReportsLoader(bool value) {
    isReportsLoading = value;
    // notifyListeners();
  }

  Future<void> checkExistingSoilRequest(String fieldId) async {
    try {
      final response = await _agPlusRepository.getReportsList(fieldId, 1);
      final data = response["data"] as List<dynamic>?;
      if (data != null && data.isNotEmpty) {
        final hasActiveRequest = data.any((req) =>
            req["status"] == "PENDING" || req["status"] == "INPROGRESS");
        requestStatus = hasActiveRequest;
      } else {
        requestStatus = false;
      }
      notifyListeners();
    } catch (error) {
      requestStatus = false;
      notifyListeners();
    }
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
          "cropId": selectedPlot.cropId,
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
      notifyListeners();
    } catch (error) {
      setRequestLoader(false);
      final errorMsg = error.toString().toLowerCase();
      if (errorMsg.contains("already") || error.toString().contains("पहले ही")) {
        requestStatus = true;
      } else {
        requestStatus = false;
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              Utils.getBackendErrorMessage(error, context),
              context);
        }
      }
      notifyListeners();
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

  void changeCropFromField(BuildContext context, String fieldId,
      {bool wasCropEmpty = false}) async {
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
        'fieldId': fieldId,
        "area": "$fieldSize $areaUnit",
        "sowingDate": sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null,
        "sowingSeason": res != null ? res["season"] : null,
        if (selectedDuration != null) "durationId": selectedDuration["_id"],
        if (varietyName.isNotEmpty) "verity": varietyName,
      };
      dynamic data;
      if (!wasCropEmpty) {
        data = await _agPlusRepository.changeCrop(payload, fieldId);
      } else {
        data = await _agPlusRepository.updateField(selectedPlot.id, payload);
      }
      selectedPlot.cropId = selectedChangeCrop!.id;
      selectedPlot.cropName = selectedChangeCrop!.name;
      selectedPlot.cropNameHi = selectedChangeCrop!.name_hi;
      selectedPlot.cropImage = selectedChangeCrop!.backgroundImage;
      selectedPlot.isMonitoringOpted = false;
      selectedPlot.area = "$fieldSize $areaUnit";
      selectedPlot.ndviId = null;
      selectedPlot.sowingDate =
          sowingDate != null ? sowingDate.toLocal().toString().split(' ')[0] : null;
      selectedPlot.currentStageId = data['data']["currentCropStage"] ?? "";
      selectedPlot.cropHistoryId = data['data']["cropHistoryId"] ?? "";
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
  void getWeedProtectionData(BuildContext context, String cropId, String selectedWeedType,
      MedicineViewModel medicineViewModel) async {
    setWeedProtectionLoader(true);
    try {
      final res = await _agPlusRepository.getWeedProtectionData(cropId);
      if (res != null && res is Map<String, dynamic>) {
        weedProtection = WeedProtection.fromJson({
          "organic": res["organic"] ?? [],
          "chemical": res["chemical"] ?? [],
        });
        selectedAdvisory = weedProtection.getByType(selectedWeedType)[0];
        if (context.mounted) {
          medicineViewModel.getWeedManageList(context, selectedAdvisory!.id);
        }
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
  void _attachDetailsAndAudio(PestDiseaseDetailResponse response) {
    pestDiseaseData = PestDiseaseData(
      pests: pestDiseaseData.pests.map((obj) {
        if (obj.id == response.id) {
          return obj.copyWith(
            audioEn: response.audioEn,
            audioHi: response.audioHi,
            details: response.details,
          );
        }
        return obj;
      }).toList(),
      diseases: pestDiseaseData.diseases.map((obj) {
        if (obj.id == response.id) {
          return obj.copyWith(
            audioEn: response.audioEn,
            audioHi: response.audioHi,
            details: response.details,
          );
        }
        return obj;
      }).toList(),
    );
  }

  void getPestsDiseaseList(BuildContext context, Plots selectedPlot, String type) async {
    try {
      setPestDataLoader(true);

      final localStorage = await SharedPreferences.getInstance();
      final rawProfile = localStorage.getString('profile');
      final profile = jsonDecode(rawProfile!);
      final userState = profile['user']?['state'].toString().replaceAll(" ", "_").toLowerCase();
      final res = await _agPlusRepository.getPestAndDiseaseList(selectedPlot.cropId!,
          selectedPlot.currentStageId!, selectedPlot.sowingSeason, userState!, type);
      if (res != null && res["data"].isNotEmpty) {
        final parsed = PestDiseaseData.fromApiResponse(res);
        pestDiseaseData = PestDiseaseData(
          pests: type == "pest" ? parsed.pests : pestDiseaseData.pests,
          diseases: type == "disease" ? parsed.diseases : pestDiseaseData.diseases,
        );

        if (type == "pest") pestsLoaded = true;
        if (type == "disease") diseasesLoaded = true;
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
    }
  }

  Future<PestDiseaseResolvedData?> resolvePestDiseaseDetails(
    BuildContext context,
    String id,
  ) async {
    // 🔹 STEP 1: check cache first
    final existing = [
      ...pestDiseaseData.pests,
      ...pestDiseaseData.diseases,
    ].firstWhere(
      (e) => e.id == id,
    );

    if (existing != null && existing.details != null && existing.details!.isNotEmpty) {
      return PestDiseaseResolvedData(
        details: existing.details!,
        audioEn: existing.audioEn ?? "",
        audioHi: existing.audioHi ?? "",
      );
    }

    setPestDetailsLoader(true);
    try {
      final res = await _agPlusRepository.getPestAndDiseaseData(id);
      if (res == null) return null;

      final parsed = PestDiseaseDetailResponse.fromJson(res["data"]);

      _attachDetailsAndAudio(parsed);

      return PestDiseaseResolvedData(
        details: parsed.details,
        audioEn: parsed.audioEn,
        audioHi: parsed.audioHi,
      );
    } catch (e) {
      return null;
    } finally {
      setPestDetailsLoader(false);
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

  //Methods for mandi near field
  void setNearbyMandiLoader(bool value) {
    isNearbyMandiDataLoading = value;
    notifyListeners();
  }

  void clearNearbyMandis() {
    nearbyMandis.clear();
    isNearbyMandiDataLoading = false;
  }

  void getNearbyMandi(BuildContext context, String cropId) async {
    setNearbyMandiLoader(true);
    try {
      final data = await _agPlusRepository.getFieldMandiData(cropId);
      if (data == null || !data.containsKey("mandis") || data["mandis"] is! List) {
        setNearbyMandiLoader(false);
        return;
      }

      final List mandis = data["mandis"];

      if (mandis.isNotEmpty) {
        nearbyMandis = mapNearbyMandis(mandis);
      }

      setNearbyMandiLoader(false);
    } catch (error) {
      setNearbyMandiLoader(false);
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  List<NearbyMandi> mapNearbyMandis(dynamic mandis) {
    return List<NearbyMandi>.from(mandis.map((mandi) {
      return NearbyMandi.fromJson(mandi);
    }));
  }

  void setIsYieldDataLoader(bool value) {
    isYieldDataProcessing = value;
    notifyListeners();
  }

  void setSelectedYieldUnit(String value) {
    selectedYieldUnit = value;
    notifyListeners();
  }

  void postYieldDataFromPopup(BuildContext context, String cropHistoryId,
      {bool isFromDelete = false}) async {
    setIsYieldDataLoader(true);
    try {
      final yieldValue = yieldController.text.trim();
      if (yieldValue.isEmpty) {
        Utils.toastMessage(AppLocalization.of(context).getTranslatedValue("yieldError").toString());
        return;
      }
      final payload = {"yieldAmount": yieldValue, "yieldUnit": selectedYieldUnit};
      await _agPlusRepository.postYieldDataFromPopup(cropHistoryId, payload);
      selectedPlot.isYieldAdded = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
        Future.microtask(() {
          if (context.mounted) {
            if (!isFromDelete) {
              fetchCropCategories(context);
              Utils.model(
                  context,
                  CropSelection(
                    isFromFieldScreen: true,
                    fieldId: selectedPlot.id,
                  ));
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DeleteFieldWarningScreen(),
                ),
              );
            }
          }
        });
        yieldController.clear();
        selectedPlot.isHarvesting = true;
        setSelectedYieldUnit("kg");
        setIsYieldDataLoader(false);
      });
    } catch (error) {
      setIsYieldDataLoader(false);
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }
}

class PestDiseaseResolvedData {
  final List<PestDiseaseDetail> details;
  final String audioEn;
  final String audioHi;

  PestDiseaseResolvedData({
    required this.details,
    required this.audioEn,
    required this.audioHi,
  });
}
