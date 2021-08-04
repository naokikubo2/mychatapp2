import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp2/Model/room_model.dart';
import 'package:mychatapp2/Model/user_state.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final RoomModel roomModel = Provider.of<RoomModel>(context);
    String latestMessage = '';
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
                  if (document['latestMessage'] != null){
                    latestMessage = document['latestMessage'];
                  }
                  return GestureDetector(
                    onTap: () async{
                      roomModel.fetchRoom(document.id);
                      await Navigator.pushNamed(context, "/chat");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          (document['imagePath'] != '') ?
                          Container(
                              padding: EdgeInsets.all(2),
                              width: 75,
                              height: 75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(document['imagePath'], fit: BoxFit.fill,),
                              )
                          ):
                          Container(
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                radius: 35,
                                  backgroundImage: AssetImage('images/エレキギター_アイコン.png'),
                              )
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            padding: EdgeInsets.only(left: 20,),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(document['name'], style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    latestMessage,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),),
                              ],
                            ),
                          ),
                        ],
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
        child: Icon(CupertinoIcons.add),
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
      body: Consumer<RoomModel>(
        builder: (context, model, child) {
          return Center(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //width: double.infinity,
                        child: Column(
                            children:[
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: InkWell(
                                  onTap: ()async{
                                    await model.showImagePicker();
                                  },
                                  child: model.imageFile != null ?
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(model.imageFile!, fit: BoxFit.fill,)
                                  )
                                      :
                                  Stack(
                                      children:[
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          width: 200,
                                          height: 200,
                                          child: CircleAvatar(
                                              radius: 35,
                                              backgroundImage: AssetImage('images/エレキギター_アイコン.png')
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(70),
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Image(image: AssetImage('images/upload_icon.png'), fit: BoxFit.fill,),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
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
                            final email = user.email; // AddPostPage のデータを参照
                            // 投稿メッセージ用ドキュメント作成
                            if(model.imageFile == null) {
                              await model.setRoom(messageText, email!);
                            }else{
                              await model.setRoomImage(messageText, email!, model.imageFile!);
                              model.endLoading();
                            }
                            model.imageFile = null;
                            // 1つ前の画面に戻る
                            Navigator.of(context).pop();
                          },),
                      ),
                    ],
                  ),
                ),
                model.isLoading ? Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : Container(),
              ]
            ),
          );
        }
      ),
    );
  }
}