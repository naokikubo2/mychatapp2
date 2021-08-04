import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class RoomModel extends ChangeNotifier {
  String roomId = '';
  String latestMessage = '';
  File? imageFile;

  bool isLoading = false;

  startLoading(){
    isLoading = true;
    notifyListeners();
  }

  endLoading(){
    isLoading = false;
    notifyListeners();
  }

  void fetchRoom(String roomId){
    this.roomId = roomId;
    notifyListeners();
  }

  Future setRoomImage(String roomName,String email, File imageFile) async{
    startLoading();
    imageUrl = await _uploadImage(imageFile);
    await FirebaseFirestore.instance
        .collection('rooms') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'name': roomName,
      'email': email,
      'latestMessage': 'メッセージがありません。',
      'imagePath': imageUrl,
    });
    notifyListeners();
  }

  Future setRoom(String roomName,String email) async{
    await FirebaseFirestore.instance
        .collection('rooms') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'name': roomName,
      'email': email,
      'latestMessage': 'メッセージがありません。',
      'imagePath': '',
    });
    notifyListeners();
  }


  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickerFile!.path);
    notifyListeners();
  }

  String imageUrl='';
  Future<String> _uploadImage(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final timeStamp = Timestamp.now();
    final String fileName = basename(file.path);
    Reference ref = storage.ref().child("images/room/$timeStamp-$fileName");
    UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot downloadUrl= (await uploadTask);
    final String url= await downloadUrl.ref.getDownloadURL();
    return url;
  }
}