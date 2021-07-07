import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class RootPage extends StatefulWidget {
  //RootPage({required Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override

  initState() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      if (currentUser == null) {
        {
          Navigator.pushReplacementNamed(context, "/login");
        }
      } else {
        Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: currentUser.uid)
            .snapshots();
        print('aaaaaaaaaaaaaaaa');
        print(snapshot);

        //if(snapshot.isEmpty){
        //    .then((DocumentSnapshot result) =>
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }));

      }
    } catch (e) {

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}