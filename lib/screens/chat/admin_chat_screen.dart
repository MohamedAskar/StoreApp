import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:store/models/user.dart';
import 'package:store/widgets/chat/messages.dart';
import 'package:store/widgets/chat/new_message.dart';

class AdminChatScreen extends StatefulWidget {
  final User user;
  final String token;
  AdminChatScreen({this.user, this.token});

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  Future<String> token;
  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          leading: BackButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            color: Colors.black,
          ),
          title: Text(
            'Chatting with ${widget.user.fullName.split(' ')[0]}',
            style: Theme.of(context).textTheme.headline3,
          ),
          actions: [
            InkWell(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'End Chat',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
              ),
              onTap: () async {
                final chatRef = Firestore.instance
                    .collection('Chats')
                    .document('Admin. ${widget.user.email}');
                final chat = await chatRef.get();

                if (chat.data['chatStarted'] && chat.data['chatRequested']) {
                  return showDialog(
                      context: context,
                      barrierDismissible: true,
                      child: AlertDialog(
                        title: Text(
                          'Close chat',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        content: Text(
                          'Do you want to close this chat?',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                          FlatButton(
                              onPressed: () async {
                                chatRef.updateData({
                                  'chatRequested': false,
                                  'chatStarted': false
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Yes',
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                        ],
                      ));
                }
                if (!chat.data['chatRequested']) {
                  return showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: AlertDialog(
                        title: Text(
                          'Close chat',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        content: Text(
                          "This user has not requested a 'chat with Admin' yet!",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Okay',
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                        ],
                      ));
                }
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('Chats')
                .document('Admin. ${widget.user.email}')
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!chatSnapshot.data['chatRequested']) {
                return Center(
                    child: Text('The user has\'s requested a chat yet!'));
              }
              if (chatSnapshot.data['chatRequested'] &&
                  !chatSnapshot.data['chatStarted']) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New chat request!',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 80.0,
                        backgroundImage: NetworkImage(widget.user.picture),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.user.fullName,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 14.0,
                      ),
                      FlatButton(
                          onPressed: () async {
                            final chatRoomRef = Firestore.instance
                                .collection('Chats')
                                .document('Admin. ${widget.user.email}');
                            final firebaseUser =
                                await FirebaseAuth.instance.currentUser();
                            chatRoomRef.updateData({'chatStarted': true});
                            chatRoomRef
                                .collection('ChatRoom')
                                .document('WelcomeMessage')
                                .setData({
                              'text':
                                  'Hi ${widget.user.fullName.split(" ")[0]}, I\'m Here to help you. How are you today?',
                              'createdAt': Timestamp.now(),
                              'pushToken': await token,
                              'chattingWith': widget.user.token,
                              'sentFrom': firebaseUser.email,
                              'sentTo': widget.user.email,
                            });
                          },
                          child: Text(
                            'Start chat',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.black, width: 1)))
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Center(
                    child:
                        Text('You are chatting with ${widget.user.fullName}'),
                  ),
                  Expanded(child: Messages(user: widget.user)),
                  NewMessage(user: widget.user, token: widget.token),
                ],
              );
            }));
  }
}
