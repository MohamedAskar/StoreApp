import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/models/user.dart';
import 'package:store/widgets/chat/chat_bubble.dart';

class Messages extends StatelessWidget {
  final User user;
  Messages({this.user});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
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
                .document((user != null)
                    ? 'Admin. ${user.email}'
                    : 'Admin. ${userSnapshot.data.email}')
                .collection('ChatRoom')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shrinkWrap: true,
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) {
                  return ChatBubble(
                    message: chatDocs[index]['text'],
                    name: (chatDocs[index]['sentFrom'].contains('@store.com'))
                        ? 'Admin'
                        : '',
                    timestamp: chatDocs[index]['createdAt'],
                    isMe:
                        chatDocs[index]['sentFrom'] == userSnapshot.data.email,
                    key: ValueKey(chatDocs[index].documentID),
                  );
                },
              );
            },
          );
        });
  }
}
