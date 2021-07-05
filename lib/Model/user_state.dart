import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserState extends ChangeNotifier {
  User? user;

  //var user = firebase.auth().currentUser;

  void createUser(User newUser) {
    user = newUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(newUser.uid)
        .set({
    "uid": newUser.uid,
    "email": newUser.email,
    });
    notifyListeners();
  }

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