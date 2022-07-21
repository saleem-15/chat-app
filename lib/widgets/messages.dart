import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/dao/files_manager.dart';
import 'package:chat_app/widgets/video_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:voice_message_package/voice_message_package.dart';

import '../helpers/message_bubble_settings.dart';
import '../utils/utils.dart';
import 'image_message.dart';
import 'message_bubble.dart';

class Messages extends StatefulWidget {
  const Messages({required this.chatPath, super.key});

  final String chatPath;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (controller) => StreamBuilder(
        stream: controller.getMessages(widget.chatPath),
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
              final isMyMessage = controller.myUser.uid == senderId ? true : false;
              final type = chatDocs[index]['type'];
              final timeSent = Utils.formatDate((chatDocs[index]['createdAt']));
              switch (type) {
                case 'text':
                  return MessageBubble(
                    username: senderName,
                    userImage: senderImage,
                    textMessage: msg,
                    isMyMessage: isMyMessage,
                    isSequenceOfMessages: false,
                    timeSent: timeSent,
                  );
                case 'image':
                  FileManager.instance.saveImageFromNetwork(chatDocs[index]['image'], widget.chatPath);
                  return ImageMessageBubble(
                    timeSent: timeSent,
                    username: senderName,
                    isMyMessage: isMyMessage,
                    imageUrl: chatDocs[index]['image'],
                    text: msg,
                  );

                case 'video':
                  return VideoMessageBubble(
                    videoUrl: chatDocs[index]['video'],
                    isMyMessage: isMyMessage,
                  );

                case 'audio':
                  return Row(
                    mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: isMyMessage ? 8 : 0,
                          left: isMyMessage ? 0 : 8,
                          bottom: 5,
                          top: 3,
                        ),
                        child: VoiceMessage(
                          audioSrc: chatDocs[index]['audio'],
                          contactBgColor: isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor,

                          //  played: true, // To show played badge or not.
                          me: isMyMessage, // Set message side.
                          onPlay: () {}, // Do something when voice played.
                        ),
                      ),
                    ],
                  );

                default:
                  return MessageBubble(
                    username: senderName,
                    userImage: senderImage,
                    textMessage: msg,
                    isMyMessage: isMyMessage,
                    isSequenceOfMessages: false,
                    timeSent: timeSent,
                  );
              }
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

                timeSent: timeSent,
                //
                isMyMessage: chatDocs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                isSequenceOfMessages: isSequenceOfMessages,
              );
            });
      },
*/
