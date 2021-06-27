import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp2/Model/room_model.dart';
import 'package:mychatapp2/Model/user_state.dart';
import 'package:provider/provider.dart';

import '../footer.dart';
import 'chat_page.dart';

class RoomPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final RoomModel roomModel = Provider.of<RoomModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ルーム'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          // 投稿メッセージ一覧を取得（非同期処理）
          // 投稿日時でソート
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .snapshots(),
          builder: (context, snapshot) {
            // データが取得できた場合
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              // 取得した投稿メッセージ一覧を元にリスト表示
              return ListView(
                children: documents.map((document) {
                  return Card(
                    child: new InkWell(
                      onTap: () async{
                        roomModel.setRoom(document.id);
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ChatPage();
                          }),
                        );
                      },
                      child: ListTile(
                        title: Text(document['name']),
                        subtitle: Text(document['email']),
                        // 自分の投稿メッセージの場合は削除ボタンを表示
                      ),
                    ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.wand_stars),
        onPressed: () async{
          //処理
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddRoomPage();
            }),
          );
        },
      ),
    );
  }
}

// 投稿画面用Widget
class AddRoomPage extends StatefulWidget {
  AddRoomPage();

  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      appBar: AppBar(
          title: Text('ルーム作成')
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration: InputDecoration(labelText: 'ルーム名'),
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
                  child: Text('作成'),
                  onPressed: () async {
                    final date =
                    DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('rooms') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                      'name': messageText,
                      'email': email,
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