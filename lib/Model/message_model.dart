import 'package:flutter/cupertino.dart';

class MessageModel extends ChangeNotifier {
  //final User sender;
  //final String time;
  String text ='';
  //final bool unread;


  void setMessage(String textMessage) {
    text = textMessage;
    notifyListeners();
  }
}