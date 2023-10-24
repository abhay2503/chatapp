import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id="chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _firestore=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;

  String? message;
  final MessageTextController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  //access the email authenticated and stored in variable auth
  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser!;
      if (user != null)  {
        loggedInUser=user;
        print(loggedInUser!.email);
      }
    }
    catch(e)
    {
      print(e);
    }
  }

  //sending data when this function is triggered by click
  // void messageStream() async {
  //   final messages= await _firestore.collection('messages').get();
  //   for( var message in messages.docs)
  //     {
  //
  //       print(message.data());
  //     }
  // }

  // void messageStream() async {
  //   await for (var snapshots in  _firestore.collection('messages').snapshots()){
  //       for( var message in snapshots.docs)
  //         {
  //           print(message.data());
  //         }
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // messageStream();
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
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                  final messages=snapshot.data?.docs.reversed;
                  List<Widget> messageWidgets=[];
                  for (var message in messages!)
                    {
                      final messageText=message.data()['text'];
                      final sender=message.data()['sender'];

                      final currentUser=loggedInUser!.email;


                      final messageWidget=MessageBubbles(
                        sender: sender,
                        text: messageText,
                        isMe: currentUser==sender,
                      );
                      messageWidgets.add(messageWidget);
                    }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                      children:messageWidgets ,
                    ),
                  );


              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: MessageTextController,
                      style: TextStyle(
                         color: Colors.black
                      ),
                      onChanged: (value) {
                       setState(() {
                         message=value;
                       });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      MessageTextController.clear();
                      _firestore.collection('messages').add({
                        'sender':loggedInUser!.email,
                        'text':message,
                        'timestamp':FieldValue.serverTimestamp()
                      });

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


class MessageBubbles extends StatelessWidget {
  const MessageBubbles({required this.sender,required this.text,required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(

        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 13,color: Colors.black54,fontWeight: FontWeight.w400),),
          Material(

            borderRadius:isMe? BorderRadius.only(topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)):BorderRadius.only(topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe?Colors.lightBlueAccent:Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Text(
                    text,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isMe?Colors.white:Colors.black
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

