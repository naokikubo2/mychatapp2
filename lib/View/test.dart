import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp2/Model/message_model.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  @override

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('チャット'),
        ),
      body: Container(
        child: ElevatedButton(
          onPressed: getImageFromGallery,
          child: Text('test'),
        ),
      ),
    );
  }
}