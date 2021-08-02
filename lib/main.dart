import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mychatapp2/Model/room_model.dart';
import 'package:mychatapp2/View/login_page.dart';
import 'package:mychatapp2/root.dart';
import 'package:provider/provider.dart';

import 'package:mychatapp2/Model/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/message_model.dart';
import 'View/chat_page.dart';
import 'View/home_page.dart';
import 'View/room_page.dart';
import 'footer.dart';
import 'header.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //var email = prefs.getString('email');
  //runApp(MaterialApp(home: email == null ? LoginPage() : HomePage()));
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  // ユーザーの情報を管理するデータ
  final UserState userState = UserState();
  final RoomModel roomModel = RoomModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserState>(create: (_)=> UserState()),
        ChangeNotifierProvider<RoomModel>(create: (_)=> RoomModel()),
        ChangeNotifierProvider<MessageModel>(create: (_)=> MessageModel()),
      ],
      child: MaterialApp(
        title: 'ChatApp',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.lightBlueAccent,
          accentColor: Colors.lightBlueAccent[600],
        ),
        home: _LoginCheck(),
          routes: <String,WidgetBuilder>{
            '/home':(BuildContext context) => HomePage(),
            '/login':(BuildContext context) => LoginPage(),
            '/room':(BuildContext context) => RoomPage(),
            '/chat':(BuildContext context) => ChatPage(),
          }
      ),
    );
  }
}

class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    final bool _loggedIn = Provider.of<UserState>(context).checkUser();
    return _loggedIn
        ? HomePage() : LoginPage();
  }
}

