import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserState extends ChangeNotifier {
  User? user;

  //var user = firebase.auth().currentUser;



  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  bool checkUser(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    return user != null;
  }
}