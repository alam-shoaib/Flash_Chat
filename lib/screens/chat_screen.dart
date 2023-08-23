import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
final _firestore=FirebaseFirestore.instance;
User LoggedIn;
class ChatScreen extends StatefulWidget {
  static const String id='chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  String messageTyped;
  @override
  void initState() {
    super.initState();
    instance();
  }
  void instance()async
  {
    try{
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          LoggedIn=user;
        });

       print(LoggedIn);
      }
    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageTyped=value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add(
                          {
                            'text': messageTyped,
                            'sender':LoggedIn.email,
                            'timestamp':FieldValue.serverTimestamp(),
                          }
                      );
                      messageController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessagesStream extends StatelessWidget {

  final currentUser=LoggedIn.email;
  @override
  Widget build(BuildContext context) {
    return             StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
        builder: (context,snapshot)
        {
          List<MessageBubble> messageList=[];
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages=snapshot.data.docs.reversed;
          for(var message in messages)
          {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageWidget=MessageBubble(sender: messageSender,text: messageText,isMe: currentUser==messageSender,);
            messageList.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              children: messageList,
            ),
          );
        }

    );
  }
}

class MessageBubble  extends StatelessWidget {
  final text;
  final sender;
  final bool isMe;
  MessageBubble({this.text,this.sender,this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
          color: isMe?Colors.lightBlueAccent:Colors.white,
          borderRadius:isMe?BorderRadius.only(
              topLeft:Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)):
          BorderRadius.only(topRight:Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Text(text,
            style: TextStyle(
              fontSize: 15.0,
              color: isMe?Colors.white:Colors.black54
            ),),
          ),
        ),]
      ),
    );
  }
}

