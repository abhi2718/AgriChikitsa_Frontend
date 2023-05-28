import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/socket_io.dart';

class HomeTabViewModel with ChangeNotifier {
  final _homeTabRepository = HomeTabRepository();
  var _loading = true;
  bool isOnline = false;
  dynamic assignedTask;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void handleAssignedTask(
      SocketService socketService, AuthService authService) {
    final newTask = socketService.newTask;
    if (newTask != null) {
      final userId = User.fromJson(authService.userInfo["user"]).sId;
      final List assignedWorkers = newTask["assignedWorkers"];
      if (assignedWorkers.contains(userId)) {
        assignedTask = newTask;
        notifyListeners();
      }
    }
  }

  void fetchAssignedTasks(BuildContext context, AuthService authService) async {
    final userId = User.fromJson(authService.userInfo["user"]).sId!;
    try {
      final data = await _homeTabRepository.fetchAssignedTask(userId);
      setloading(false);
      assignedTask = data["data"];
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void initializeSocket(SocketService socketService) async {
    final localStorage = await SharedPreferences.getInstance();
    final isOnline = localStorage.getBool("isOnline");
    if (isOnline == true) {
      socketService.connect();
      this.isOnline = true;
      notifyListeners();
    }
  }

  void handleSwitchToggle(bool newValue, SocketService socketService) async {
    try {
      final localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("isOnline", newValue);
      isOnline = newValue;
      if (newValue) {
        socketService.connect();
      } else {
        socketService.disconnect();
      }
      notifyListeners();
    } catch (error) {
      Utils.toastMessage(error.toString());
    }
  }

  void getUserProfile(AuthService authService) async {
    final localStorage = await SharedPreferences.getInstance();
    final rawProfile = localStorage.getString('profile');
    final profile = jsonDecode(rawProfile!);
    authService.setUser(profile);
  }

  void handleChangeAssignedTaskStatus(
      BuildContext context, SocketService socketService) async {
    try {
      final taskId = assignedTask["_id"];
      final payload = {"status": "Awaiting approval"};
      final data =
          await _homeTabRepository.changeAssignedTaskStatus(taskId, payload);
      assignedTask = data;
      socketService.handleTaskStatus(data["_id"]);
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void disposeValues() {
    _loading = true;
    isOnline = false;
    assignedTask = null;
  }
}
