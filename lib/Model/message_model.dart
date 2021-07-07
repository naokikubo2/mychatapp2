import 'package:flutter/cupertino.dart';

class MessageModel extends ChangeNotifier {
  //final User sender;
  //final String time;
  String text ='';
  //final bool unread;


  Future setMessage(String textMessage) async{
    text = textMessage;
    notifyListeners();
  }
}