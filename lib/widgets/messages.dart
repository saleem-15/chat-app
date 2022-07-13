import 'package:chat_app/controllers/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({required this.chatId, super.key});

  final chatId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (controller) => StreamBuilder(
        stream: controller.getMessages(chatId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final chatDocs = snapshot.data?.docs;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            reverse: true,
            itemCount: chatDocs!.length,
            itemBuilder: (context, index) {
              final senderName = chatDocs[index]['senderName'];
              final senderId = chatDocs[index]['senderId'];
              final senderImage = chatDocs[index]['senderImage'];
              final msg = chatDocs[index]['text'];
              final isMyMessage = controller.user.uid == senderId ? true : false;

              return MessageBubble(
                username: senderName,
                userImage: senderImage,
                textMessage: msg,
                isMyMessage: isMyMessage,
                isSequenceOfMessages: false,
                timeSent: Utils.formatDate((chatDocs[index]['createdAt'])),
              );
            },
          );
        },
      ),
    );
  }
}

/*
builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final chatDocs = chatSnapshot.data?.docs;

        return ListView.builder(
            reverse: true,
            itemCount: chatSnapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var isSequenceOfMessages = index <= 1
                  ? false
                  : chatDocs![index - 1]['username'] ==
                          chatDocs[index]['username']
                      ? true
                      : false;
              return MessageBubble(
                //
                textMessage: chatDocs![index]['text'],
                //
                username: chatDocs[index]['username'],
                //
                userImage: chatDocs[index]['userImage'],

                timeSent: Utils.formatDate((chatDocs[index]['createdAt'])),
                //
                isMyMessage: chatDocs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                isSequenceOfMessages: isSequenceOfMessages,
              );
            });
      },
*/
