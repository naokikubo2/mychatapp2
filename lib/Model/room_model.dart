import 'package:flutter/cupertino.dart';

class RoomModel extends ChangeNotifier {
  String roomId = '';
  String latestMessage = '';

  void setRoom(String roomId) {
    this.roomId = roomId;
    notifyListeners();
  }
}