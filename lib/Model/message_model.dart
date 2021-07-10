import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'message.dart';

class MessageModel extends ChangeNotifier {
  List<Message> messages = [];

  void fetchMessages(String roomId) {
    final snapshots = FirebaseFirestore.instance
        .collection('messages')
        .where('roomId', isEqualTo: roomId)
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final messages = docs.map((doc) => Message(doc)).toList();
      messages.sort((a, b) => b.createAt.compareTo(a.createAt));
      this.messages = messages;
      notifyListeners();
    });
  }

  Future setMessage(String text, String uid, String roomId) async{
    final createAt = DateTime.now().toLocal(); // 現在の日時
    // 投稿メッセージ用ドキュメント作成
    await FirebaseFirestore.instance
        .collection('messages') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'text': text,
      'uid': uid,
      'createAt': createAt,
      'roomId': roomId,
      'imagePath': '',
      'unread': true,
    });
    notifyListeners();
  }
}