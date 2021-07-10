import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String text;
  late String roomId;
  late String uid;
  late bool unread;
  late String imagePath;
  late DateTime createAt;
  //Message(this.text, this.roomId, this.uid, this.unread, this.imagePath, this.createAt);
  Message(DocumentSnapshot doc){
    this.text = doc['text'];
    this.roomId = doc['roomId'];
    this.uid = doc['uid'];
    this.unread = doc['unread'];
    this.imagePath = doc['imagePath'];

    final Timestamp timestamp = doc['createAt'];
    this.createAt = timestamp.toDate();
  }
}