import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/auth.repo/auth_repository.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';

class SignUpViewModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final verifyUserformKey = GlobalKey<FormState>();
  final registerUserformKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final mobileNumberFocusNode = FocusNode();
  var _userId = '';
  var _loading = false;
  var isVerified = false;
  var userName = '';
  var email = '';
  var password = '';
  var confirmPassword = '';
  var mobileNumber = '';
  dynamic userProfile;
  bool showPassword = false;
  bool showConfirmPassword = false;

  bool get loading {
    return _loading;
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setUserProfile(user) {
    userProfile = user;
    notifyListeners();
  }

  void setUserInfo(String name, String companyId) {
    userName = name;
    _userId = companyId;
    notifyListeners();
  }

  void setIsVerified(bool value) {
    isVerified = value;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Verification of worker with employee Id
  void saveVerifyUserForm() {
    final isValid = verifyUserformKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    verifyUserformKey.currentState?.save();
  }

  String? employeeIdFieldValidator(value) {
    if (value!.isEmpty) {
      return "Employee ID is required!";
    }
    return null;
  }

  void onEmployeeIdFieldSubmitted(value) {
    saveVerifyUserForm();
  }

  Widget suffixIconForEmployeeId() {
    return const Icon(Icons.account_box);
  }

  void onSavedEmployeeIdField(value, context) {
    setloading(true);
    const delay = Duration(milliseconds: 1000);
    Timer(delay, () => verifyUser(value, context));
  }

  void verifyUser(String enployeeId, BuildContext context) async {
    try {
      final data = await _authRepository.verifyUser(enployeeId);
      setUserInfo(data['name'], data['companyId']);
      setloading(false);
      setIsVerified(true);
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
      setloading(false);
    }
  }

// User Registration Logic
  void saveRegisterUserForm(BuildContext context) {
    final isValid = registerUserformKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    registerUserformKey.currentState?.save();
    if (!matchPasswords(password, confirmPassword)) {
      Utils.flushBarErrorMessage(
          "Alert!", "Password and confirm password does not matched!", context);
      return;
    }
    final userInfo = {
      "updateType": "register",
      "companyId": _userId,
      "name": userName,
      "email": email,
      "password": password,
      "phoneNumber": mobileNumber,
    };
    register(userInfo, context);
  }

// Name TextField
  Widget suffixIconForName() {
    return const Icon(Icons.person);
  }

  String? nameFieldValidator(value) {
    if (value!.isEmpty) {
      return "Name is required!";
    }
    return null;
  }

  void onSavedNameField(value) {
    userName = value;
  }

  // Email TextField
  Widget suffixIconForEmail() {
    return const Icon(Icons.email);
  }

  bool validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? emailFieldValidator(value) {
    if (value!.isEmpty) {
      return "Email is required!";
    }
    bool isValid = validateEmail(value);
    if (!isValid) {
      return "Please enter a valid email";
    }
    return null;
  }

  void onSavedEmailField(value) {
    email = value;
  }

  //  Password TextField
  bool validatePassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Widget suffixIconForPassword() {
    return GestureDetector(
      onTap: () {
        showPassword = !showPassword;
        notifyListeners();
      },
      child: showPassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
    );
  }

  String? passwordFieldValidator(value) {
    if (value!.isEmpty) {
      return "Password is required!";
    }
    bool isValid = validatePassword(value);
    if (!isValid) {
      return "Password must contain at least 8 characters, including at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#\$&*~)";
    }
    return null;
  }

  void onSavedPasswordlField(value) {
    password = value;
  }

  // ConfirmPassword TextField
  Widget suffixIconForConfirmPassword() {
    return GestureDetector(
      onTap: () {
        showConfirmPassword = !showConfirmPassword;
        notifyListeners();
      },
      child: showConfirmPassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
    );
  }

  bool matchPasswords(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    }
    return false;
  }

  String? confirmPasswordFieldValidator(value) {
    if (value!.isEmpty) {
      return "Confirm Password is required!";
    }
    return null;
  }

  void onSavedConfirmPasswordlField(value) {
    confirmPassword = value;
  }

  // Mobile Numer TextField
  Widget suffixIconForMobileNumber() {
    return const Icon(Icons.phone);
  }

  bool validateMobileNumber(String mobile) {
    String pattern = r'^\+91[6-9][0-9]{9}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(mobile);
  }

  String? mobileNumerFieldValidator(value) {
    if (value!.isEmpty) {
      return "Mobile number is required!";
    }
    bool isValid = validateMobileNumber('+91$value');
    if (!isValid) {
      return "Please enter a valid phone number!";
    }
    return null;
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
          'user': data["user"],
          'token': data["token"],
        };
        await localStorage.setString("profile", jsonEncode(profile));
        setUserProfile(data);
        setloading(false);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.homeRoute, (route) => false);
      } catch (error) {
        Utils.flushBarErrorMessage("Alert!", error.toString(), context);
        setloading(false);
      }
    }

    handleRegister(localContext);
  }

  void disposeVerifyUserformKey() {
    verifyUserformKey.currentState?.dispose();
  }

  void disposeRegisterUserformKey() {
    registerUserformKey.currentState?.dispose();
  }

  void disposeValues() {
    _userId = '';
    _loading = false;
    isVerified = false;
    userName = '';
    email = '';
    password = '';
    confirmPassword = '';
    mobileNumber = '';
    userProfile = null;
    showPassword = false;
    showConfirmPassword = false;
  }
}
