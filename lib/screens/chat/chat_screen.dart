import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:store/widgets/chat/messages.dart';
import 'package:store/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
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
            'Help',
            style: Theme.of(context).textTheme.headline2,
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
                final user = await FirebaseAuth.instance.currentUser();
                final chatRef = Firestore.instance
                    .collection('Chats')
                    .document('Admin. ${user.email}');
                final chat = await chatRef.get();

                if (chat.data['chatRequested']) {
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
                } else {
                  return showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: AlertDialog(
                        title: Text(
                          'Close chat',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        content: Text(
                          "You have not started any chat yet! You can request a chat by clicking on 'chat with us'",
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
        body: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('Chats')
                    .document('Admin. ${userSnapshot.data.email}')
                    .snapshots(),
                builder: (context, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (chatSnapshot.data['chatStarted']) {
                    return Container(
                      child: Column(
                        children: [
                          Center(
                            child: Text('You are chatting with Admin'),
                          ),
                          Expanded(child: Messages()),
                          NewMessage(),
                        ],
                      ),
                    );
                  }

                  if (chatSnapshot.data['chatRequested'] &&
                      !chatSnapshot.data['chatStarted']) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Waiting for an Admin to respond',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${userSnapshot.data.displayName.split(' ')[0]}! How can we help you?',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'If you have any problem with your order or you want to ask about anything you can request a chat at any time. Our team is always ready to help you! '
                          'You can also take to us if you want to advertise your items in our store or anything you want. We would be happy to have you.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'FAQ',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: 250,
                        ),
                        Text(
                          'Still need some help?',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Request a new chat with one of our Customer service heros! '
                          'We really hope we can help.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: FlatButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    image: Image.asset(
                                      'assets/images/chat.gif',
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      'Request a new chat!',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    description: Text(
                                      'You can chat with us 24/7. We are always here to solve any problem, we would love to hear from you. Chat with us now!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    buttonOkText: Text(
                                      'Chat',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    buttonCancelText: Text(
                                      'Not now',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    buttonCancelColor:
                                        Colors.red.withOpacity(0.9),
                                    entryAnimation: EntryAnimation.LEFT,
                                    onOkButtonPressed: () {
                                      Firestore.instance
                                          .collection('Chats')
                                          .document(
                                              'Admin. ${userSnapshot.data.email}')
                                          .updateData({'chatRequested': true});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Start a new chat',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: Colors.black, width: 1))),
                        )
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
