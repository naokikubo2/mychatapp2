import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class RoomModel extends ChangeNotifier {
  String roomId = '';
  String latestMessage = '';

  void setRoom(String roomId) {
    this.roomId = roomId;
    notifyListeners();
  }

  File? imageFile;
  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickerFile!.path);
    notifyListeners();
  }

  String imageUrl='';
  Future<String> _uploadImage(File file, String uid) async {
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