import 'package:flutter/foundation.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;

class SocketService with ChangeNotifier {
  dynamic newTask;
  final socket = socket_io_client.io('http://192.168.1.5:1010', {
    "transports": ['websocket'],
    "autoConnect": false,
  });
  void handlerNewTask(data) {
    newTask = data;
    notifyListeners();
  }

  void connect() {
    socket.connect();
    socket.onConnect((_) {
      if (kDebugMode) {
        print("Connect to socket.io server");
      }
    });
    socket.emit("joinChannel", "taskChannel");
    socket.on('receiveTask', (data) {
      handlerNewTask(data);
    });
  }

  void disconnect() {
    socket.disconnect();
    if (kDebugMode) {
      print("disConnected with socket.io server");
    }
  }

  void handleTaskStatus(String id) {
    Utils.toastMessage("clickedTaskStatus");
    final payload = {
      "channelID": "taskChannel",
      "status": "Awaiting approval",
      "taskId": id
    };
    socket.emit("changeTaskStatus", payload);
  }

  void disposeValues() {
    newTask = null;
  }
}
