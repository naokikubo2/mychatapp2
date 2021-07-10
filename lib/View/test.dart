import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp2/Model/message_model.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('チャット'),
        ),
      body: ChangeNotifierProvider<MessageModel>(
        create: (_) => MessageModel()..fetchMessages('0ZlKhgPYVCJ2ITgUhssS'),
        child: Consumer<MessageModel>(
          builder: (context, model, child) {
            final messages = model.messages;


            final listTiles = messages.map((message) => ListTile(
              title: Text(message.text),),
            ).toList();
            return ListView(
              children: listTiles,
            );
          }
        ),
      ),
    );
  }
}