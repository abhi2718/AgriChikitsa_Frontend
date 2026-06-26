import 'dart:convert';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/states_district_model.dart';
import 'package:agriChikitsa/res/up_location_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/auth.repo/auth_repository.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';

class SignUpViewModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final registerUserformKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  var _loading = false;
  var userName = '';
  var email = '';
  var mobileNumber = '';
  var firebaseId = '';
  var village = '';
  dynamic stateList = [];
  dynamic districtList = [];
  dynamic blockList = [];
  StateModel? selectedState;
  var selectedDistrictHi = '';
  var selectedDistrictEn = '';
  var selectedBlockHi = '';
  var selectedBlockEn = '';
  dynamic userProfile;

  void setSelectedState(BuildContext context, StateModel value) {
    selectedState = value;
    notifyListeners();
    fetchDistrict(context, selectedState!.state);
  }

  void setSelectedDistrict(value) {
    selectedDistrictHi = value;
    notifyListeners();
    fetchBlocks(selectedDistrictEn);
  }

  void setSelectedDistrictEn(value) {
    selectedDistrictEn = value.name;
  }

  void setSelectedBlock(value) {
    selectedBlockHi = value;
    notifyListeners();
  }

  void setSelectedBlockEn(value) {
    selectedBlockEn = value.name;
  }

  bool get loading {
    return _loading;
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    mobileNumber = phoneNumber;
  }

  void setFirebaseId(String uid) {
    firebaseId = uid;
  }

  void setUserProfile(user) {
    userProfile = user;
    notifyListeners();
  }

  void setVillage(value) {
    village = value;
    notifyListeners();
  }

  void setUserInfo(String name, String companyId) {
    userName = name;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void fetchStates(BuildContext context) async {
    try {
      stateList = mapStates(upLocationData);
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  List<StateModel> mapStates(dynamic states) {
    return List<StateModel>.from(states.map((state) {
      return StateModel.fromJson(state);
    }));
  }

  void fetchDistrict(BuildContext context, String selectedStateName) async {
    try {
      districtList.clear();
      selectedDistrictEn = "";
      selectedDistrictHi = "";
      blockList.clear();
      selectedBlockEn = "";
      selectedBlockHi = "";
      
      final stateData = upLocationData.firstWhere(
        (element) => element['state'] == selectedStateName,
        orElse: () => {},
      );
      if (stateData.isNotEmpty) {
        districtList = mapDistricts(stateData['districts']);
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode && context.mounted) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  List<DistrictModel> mapDistricts(dynamic districts) {
    return List<DistrictModel>.from(districts.map((district) {
      return DistrictModel.fromJson(district);
    }));
  }

  void fetchBlocks(String districtNameEn) {
    try {
      blockList.clear();
      selectedBlockEn = "";
      selectedBlockHi = "";
      
      if (selectedState == null) return;
      
      final stateData = upLocationData.firstWhere(
        (element) => element['state'] == selectedState!.state,
        orElse: () => {},
      );
      
      if (stateData.isNotEmpty) {
        final districts = stateData['districts'] as List<dynamic>;
        final districtData = districts.firstWhere(
          (element) => element['name'] == districtNameEn,
          orElse: () => null,
        );
        if (districtData != null) {
          blockList = mapBlocks(districtData['blocks']);
        }
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching blocks: $error');
      }
    }
  }

  List<BlockModel> mapBlocks(dynamic blocks) {
    return List<BlockModel>.from(blocks.map((block) {
      return BlockModel.fromJson(block);
    }));
  }

  void saveRegisterUserForm(BuildContext context) {
    final isValid = registerUserformKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    if (selectedState == null || selectedDistrictHi.isEmpty || selectedBlockHi.isEmpty || village.isEmpty) {
      if (selectedState == null) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            AppLocalization.of(context).getTranslatedValue("validateState").toString(),
            context);
      } else if (selectedDistrictHi.isEmpty) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            AppLocalization.of(context).getTranslatedValue("validateDistrict").toString(),
            context);
      } else if (selectedBlockHi.isEmpty) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            AppLocalization.of(context).getTranslatedValue("validateBlock").toString(),
            context);
      } else if (village.isEmpty) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            AppLocalization.of(context).getTranslatedValue("validateVillage").toString(),
            context);
      }
      return;
    }
    registerUserformKey.currentState?.save();

    final userInfo = email.isEmpty
        ? {
            "roles": "User",
            "name": userName,
            "phoneNumber": mobileNumber,
            "firebaseId": firebaseId,
            "state": selectedState!.state,
            "state_hi": selectedState!.stateHi,
            "district_en": selectedDistrictEn,
            "district_hi": selectedDistrictHi,
            "block_en": selectedBlockEn,
            "block_hi": selectedBlockHi,
            "village": village
          }
        : {
            "roles": "User",
            "name": userName,
            "email": email,
            "phoneNumber": mobileNumber,
            "firebaseId": firebaseId,
            "state": selectedState!.state,
            "state_hi": selectedState!.stateHi,
            "district_en": selectedDistrictEn,
            "district_hi": selectedDistrictHi,
            "block_en": selectedBlockEn,
            "block_hi": selectedBlockHi,
            "village": village
          };
    FocusManager.instance.primaryFocus!.unfocus();
    register(userInfo, context);
  }

  Widget suffixIconForName() {
    return const Icon(Icons.person);
  }

  String? nameFieldValidator(BuildContext context, value) {
    if (value!.isEmpty) {
      return AppLocalization.of(context).getTranslatedValue("validateName").toString();
    }
    return null;
  }

  String? villageFieldValidator(BuildContext context, value) {
    if (value!.isEmpty) {
      return AppLocalization.of(context).getTranslatedValue("validateVillage").toString();
    }
    return null;
  }

  void onSavedNameField(value) {
    userName = value;
  }

  void onSavedvillageField(value) {
    village = value;
  }

  Widget suffixIconForEmail() {
    return const Icon(Icons.email);
  }

  Widget suffixIconForVillage() {
    return const Icon(Icons.cottage);
  }

  bool validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? emailFieldValidator(BuildContext context, value) {
    if (value != null && value.isNotEmpty) {
      bool isValid = validateEmail(value);
      if (!isValid) {
        return AppLocalization.of(context).getTranslatedValue("validateEmail").toString();
      }
    }
    return null;
  }

  void onSavedEmailField(value) {
    email = value;
  }

  void onSavedMobileNumerField(value) {
    mobileNumber = value;
  }

  void register(dynamic payload, BuildContext context) {
    final localContext = context;
    setloading(true);
    void handleRegister(context) async {
      try {
        final data = await _authRepository.register(payload);
        final localStorage = await SharedPreferences.getInstance();
        final profile = {
          'user': data["newUser"],
          'language': {
            "language": AppLocalization.of(context).locale.toString(),
            "country": AppLocalization.of(context).locale.toString() == "en" ? "US" : "IN"
          },
          'token': data["token"],
        };
        await localStorage.setString("profile", jsonEncode(profile));
        setUserProfile(data);
        setloading(false);
        Navigator.of(context).pushNamedAndRemoveUntil(RouteName.homeRoute, (route) => false);
        disposeValues();
      } catch (error) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
        setloading(false);
      }
    }

    handleRegister(localContext);
  }

  void disposeRegisterUserformKey() {
    registerUserformKey.currentState?.reset();
  }

  void disposeValues() {
    _loading = false;
    userName = '';
    email = '';
    mobileNumber = '';
    districtList = [];
    blockList = [];
    selectedState = null;
    selectedDistrictHi = '';
    selectedDistrictEn = '';
    selectedBlockHi = '';
    selectedBlockEn = '';
    village = '';
    userProfile = null;
    registerUserformKey.currentState?.reset();
  }
}
