import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychatapp2/Model/room_model.dart';
import 'package:provider/provider.dart';

import 'package:mychatapp2/Model/user_state.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';

// チャット画面用Widget
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    final RoomModel roomModel = Provider.of<RoomModel>(context);
    final String roomId = roomModel.roomId;

    var dateFormat = DateFormat('HH:mm:ss');

    _sendMessageArea(){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: (){},
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Send a message'
                ),
                textCapitalization: TextCapitalization.sentences ,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: (){},
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報：${user.email}'),
          ),
          Expanded(

            // StreamBuilder
            // 非同期処理の結果を元にWidgetを作れる
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得（非同期処理）
              // 投稿日時でソート

              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('roomId', isEqualTo: roomId)
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.80,
                              ),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    )
                                  ]
                              ),
                              child: Text(
                                document['text'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                dateFormat.format(DateTime.parse(document['date'])),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        )
                                      ]
                                  ),
                                  child: CircleAvatar(
                                      radius: 15,
                                      backgroundImage: AssetImage('images/user1.png')
                                  )
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
          _sendMessageArea(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage();
            }),
          );
        },
      ),
    );
  }
}

// 投稿画面用Widget
class AddPostPage extends StatefulWidget {
  AddPostPage();

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    final RoomModel roomModel = Provider.of<RoomModel>(context);
    final String roomId = roomModel.roomId;

    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration: InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('投稿'),
                  onPressed: () async {
                    final date =
                    DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('posts') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                      'text': messageText,
                      'email': email,
                      'date': date,
                      'roomId': roomId,
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

