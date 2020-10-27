import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:store/models/user.dart';

class NewMessage extends StatefulWidget {
  final User user;
  final String token;
  NewMessage({this.user, this.token});
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();
  Future<String> token;
  bool isInit;

  @override
  void initState() {
    super.initState();

    final fcm = FirebaseMessaging();
    token = fcm.getToken();
    setState(() {
      isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _controller,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
            showCursor: true,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
              fillColor: Colors.black,
              hintText: 'Send a message...',
              hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              labelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
              color: Colors.black,
              icon: Icon(
                Icons.send_outlined,
              ),
              onPressed: _enteredMessage.trim().isEmpty
                  ? null
                  : () async {
                      final user = await FirebaseAuth.instance.currentUser();
                      final firestore = Firestore.instance;

                      if (widget.user != null) {
                        firestore
                            .collection('Chats')
                            .document("Admin. ${widget.user.email}")
                            .collection('ChatRoom')
                            .add({
                          'text': _enteredMessage,
                          'createdAt': Timestamp.now(),
                          'pushToken': await token,
                          'chattingWith': widget.token,
                          'sentFrom': user.email,
                          'sentTo': widget.user.email
                        });
                      } else {
                        final adminToken = await firestore
                            .collection('Chats')
                            .document('Admin. ${user.email}')
                            .collection('ChatRoom')
                            .document('WelcomeMessage')
                            .get();
                        firestore
                            .collection('Chats')
                            .document('Admin. ${user.email}')
                            .collection('ChatRoom')
                            .add({
                          'text': _enteredMessage,
                          'createdAt': Timestamp.now(),
                          'pushToken': await token,
                          'chattingWith': adminToken.data['pushToken'],
                          'sentFrom': user.email,
                          'sentTo': adminToken.data['sentFrom'],
                        });
                      }
                      _controller.clear();
                    })
        ],
      ),
    );
  }
}
