import 'package:flutter/cupertino.dart';
import 'package:mychatapp2/Model/user_model.dart';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool unread;

  Message({
    required this.sender, required this.time, required this.text, required this.unread,
  });
}

List<Message> messages = [
  Message(
    sender: ironMan,
    time: '5:30 PM',
    text: 'コンバオンは',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '5:30 PM',
    text: 'コンバオンは',
    unread: true,
  ),
  Message(
      sender: currentUser,
      time: '5:31 PM',
      text: 'どうも',
      unread: false,
  ),
  Message(
      sender: currentUser,
      time: '5:31 PM',
      text: 'こんにちは',
      unread: true,
  ),
  Message(
      sender: miyuu,
      time: '5:39 PM',
      text: '看護師の早川美優です。よろしくお願いしまーーす！',
      unread: false,
  ),
  Message(
    sender: miyuu,
    time: '5:39 PM',
    text: '看護師の早川美優です。よろしくお願いしまーーす！',
    unread: false,
  ),
  Message(
    sender: miyuu,
    time: '5:39 PM',
    text: '看護師の早川美優です。よろしくお願いしまーーす！',
    unread: false,
  ),
  Message(
    sender: currentUser,
    time: '5:31 PM',
    text: 'どうも',
    unread: false,
  ),
  Message(
    sender: currentUser,
    time: '5:31 PM',
    text: 'こんにちは',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '5:31 PM',
    text: 'どうも',
    unread: false,
  ),
  Message(
    sender: currentUser,
    time: '5:31 PM',
    text: 'こんにちは',
    unread: true,
  ),
];
