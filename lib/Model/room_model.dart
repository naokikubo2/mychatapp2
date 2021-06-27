import 'package:flutter/cupertino.dart';

class RoomModel extends ChangeNotifier {
  String roomId = '';

  void setRoom(String roomId) {
    this.roomId = roomId;
    notifyListeners();
  }
}