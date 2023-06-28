import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../repository/auth.repo/auth_repository.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';

class SignInViewModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneNumberController = TextEditingController();
  var phoneNumber = "";
  var errorMessage = '';
  var countDown = 30;
  var showTimmer = false;
  var _loading = false;
  var showResendOTPButton = false;
  var otp = "";
  var verificationIdToken = "";
  dynamic userProfile;

  bool get loading {
    return _loading;
  }

  void setUserProfile(user) {
    userProfile = user;
    notifyListeners();
  }

  void setOTP(String code, BuildContext context) {
    otp = code;
    verifyOTPCode(verificationIdToken, code, context);
    notifyListeners();
  }

  void setCountDown() {
    if (countDown >= 0) {
      countDown = countDown - 1;
      if (countDown == 0) {
        setResendOTPButton();
      }
      notifyListeners();
    }
  }

  void disposeValues() {
    phoneNumberController.clear();
    phoneNumber = "";
    errorMessage = "";
    countDown = 30;
    showTimmer = false;
    _loading = false;
    showResendOTPButton = false;
    otp = "";
    verificationIdToken = "";
    userProfile = null;
    auth.signOut();
  }

  void resetTimer() {
    countDown = 30;
    showResendOTPButton = false;
    showTimmer = true;
  }

  void setResendOTPButton() {
    showResendOTPButton = true;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void onPhoneNumberChanged(BuildContext context, String phoneNumber) {
    phoneNumber = phoneNumber;
    if (!validateMobileNumber('+91$phoneNumber')) {
      errorMessage = AppLocalizations.of(context)!.mobileDigitCounthi;
      notifyListeners();
    } else {
      errorMessage = '';
      notifyListeners();
    }
  }

  bool validateMobileNumber(String mobile) {
    String pattern = r'^\+91[6-9][0-9]{9}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(mobile);
  }

  void reSendOTP(BuildContext context) {
    showResendOTPButton = false;
    countDown = 30;
    showTimmer = true;
    notifyListeners();
    requestOTP(context, '+91$phoneNumber');
  }

  void verifyUserPhoneNumber(BuildContext context) {
    if (!validateMobileNumber('+91${phoneNumberController.text}')) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.alerthi,
          AppLocalizations.of(context)!.mobileDigitCounthi, context);
      return;
    } else {
      setloading(true);
      phoneNumber = phoneNumberController.text;
      requestOTP(context, '+91${phoneNumberController.text}');
    }
  }

  void requestOTP(BuildContext context, phoneNumber) {
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setloading(false);
        Utils.flushBarErrorMessage("Alert!", e.message.toString(), context);
        return;
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationIdToken = verificationId;
        notifyListeners();
        setloading(false);
        Navigator.pushNamed(context, RouteName.otpVerificationRoute);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTPCode(verificationId, otp, BuildContext context) async {
    setloading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final userCredential = await auth.signInWithCredential(credential);
      login(phoneNumber, context, userCredential.user!.uid);
    } catch (e) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.alerthi,
          AppLocalizations.of(context)!.otpVerifyhi, context);
      setloading(false);
    }
  }

  void login(String phoneNumber, BuildContext context, String uid) {
    final localContext = context;
    void handleLogin(context) async {
      try {
        final data = await _authRepository.login(phoneNumber);
        if (data["newUser"]) {
          setloading(false);
          Navigator.of(context).pushNamed(RouteName.signUpRoute, arguments: {
            "phoneNumber": phoneNumber,
            "uid": uid,
          });
        } else {
          final localStorage = await SharedPreferences.getInstance();
          final profile = {
            'user': data["user"],
            'token': data["token"],
          };
          await localStorage.setString("profile", jsonEncode(profile));
          setUserProfile(data);
          setloading(false);
          resetTimer();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.homeRoute, (route) => false);
        }
      } catch (error) {
        Utils.flushBarErrorMessage("Alert!", error.toString(), context);
        setloading(false);
      }
    }

    handleLogin(localContext);
  }
}
