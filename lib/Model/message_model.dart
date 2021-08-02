import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'message.dart';

class MessageModel extends ChangeNotifier {
  List<Message> messages = [];
  bool isLoading = false;

  startLoading(){
    isLoading = true;
    notifyListeners();
  }

  endLoading(){
    isLoading = false;
    notifyListeners();
  }

  late File imageFile;
  Future showImagePicker(String uid, String roomId) async {
    final picker = ImagePicker();
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      startLoading();
      imageFile = File(pickerFile.path);
      final imageUrl = await _uploadImage(imageFile, uid);
      setMessageImage(imageUrl, uid, roomId);
    }
  }

  String imageUrl='';
  Future<String> _uploadImage(File file, String uid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final timeStamp = Timestamp.now();
    final String fileName = basename(file.path);
    Reference ref = storage.ref().child("images/chat/$timeStamp-$fileName");
    UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot downloadUrl= (await uploadTask);
    final String url= await downloadUrl.ref.getDownloadURL();
    return url;
  }

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
    setLatestMessage(roomId, text, false);
    notifyListeners();
  }

  Future setMessageImage(String imageUrl, String uid, String roomId) async{
    final createAt = DateTime.now().toLocal(); // 現在の日時
    // 投稿メッセージ用ドキュメント作成
    await FirebaseFirestore.instance
        .collection('messages') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'text': '',
      'uid': uid,
      'createAt': createAt,
      'roomId': roomId,
      'imagePath': imageUrl,
      'unread': true,
    });
    isLoading = false;
    setLatestMessage(roomId, '', true);
    notifyListeners();
  }

  setLatestMessage(String roomId, String message, bool isImage){
     if (isImage){
       message = '画像を送信しました。';
     }
    FirebaseFirestore.instance
        .collection('rooms') // コレクションID指定
        .doc(roomId) // ドキュメントID自動生成
        .update({
      'latestMessage': message,
    });
  }
}