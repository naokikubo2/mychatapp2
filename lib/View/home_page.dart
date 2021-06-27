import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp2/View/room_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../footer.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: <Widget>[
                Container(
                  height: 125,
                  padding: EdgeInsets.all(4),
                  child: ListView(
                    children: [
                      Container(
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            await Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
                          },
                          child: Text('Logout'),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the second screen when tapped.
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return RoomPage();
                                }),
                            );
                          },
                          child: Text('ルーム'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }
}