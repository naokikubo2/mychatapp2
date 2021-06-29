import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp2/Model/message_model.dart';
import 'package:mychatapp2/Model/user_model.dart';


class ChatScreen extends StatefulWidget {
  final User user;
  ChatScreen({required this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen>{
  @override
  Widget build(BuildContext context) {

    _chatBubble(Message message, bool isMe, bool isSameUser){
      if( isMe ) {
        return Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ]
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            !isSameUser ?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ]
                    ),
                    child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage('images/user1.png')
                    )
                ),
              ],
            ) :
                Container(child: null,),
          ],
        );
      }else{
        return Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ]
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            !isSameUser ?
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ]
                    ),
                    child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(message.sender.imageUrl)
                    )
                ),
                SizedBox(width: 10,),
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            )
                :
                Container(child: null,),
          ],
        );
      }
    }

    _sendMessageArea(){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: (){},
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Send a message'
                ),
                textCapitalization: TextCapitalization.sentences ,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: (){},
            )
          ],
        ),
      );
    }
    int nextUserId = 0;
    int lengthMessages =  messages.length;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: widget.user.name, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              )),
              TextSpan(text: '\n'),
              widget.user.isOnline ?
              TextSpan(text: 'Online', style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ))
                  :
              TextSpan(text: 'Offline', style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ))
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
        },)
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index){
                final Message message =  messages[index];
                final bool isMe = message.sender.id == currentUser.id;
                if(lengthMessages-1 > index) {
                  nextUserId = messages[index + 1].sender.id;
                }else{
                  nextUserId = 0;
                }
                final bool isSameUser = nextUserId == message.sender.id;
                return _chatBubble(message, isMe, isSameUser);
              },
            ),
          ),
          _sendMessageArea(),
        ],
      )
    );
  }
}
