import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String name;
  final Timestamp timestamp;
  final bool isMe;
  final Key key;

  ChatBubble(
      {@required this.message,
      @required this.name,
      @required this.timestamp,
      @required this.isMe,
      this.key});

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Bubble(
      style: isMe ? styleMe : styleSomebody,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (name.trim().isNotEmpty)
            Text(
              name,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          SizedBox(
            height: 4,
          ),
          Text(
            message,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '${DateFormat('hh:mm aaa').format(timestamp.toDate())}',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
