import 'dart:developer';
import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/widgets/video_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:voice_message_package/voice_message_package.dart';

import '../helpers/message_bubble_settings.dart';
import '../utils/utils.dart';
import 'image_message.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({required this.chatPath, super.key});

  final String chatPath;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      // assignId: true,
      // id: 'messages_list',
      builder: (controller) {
        final chat = controller.myChatsList.firstWhere((chat) => chat.value.chatPath == chatPath);
        final messages = chat.value.messages.reversed.toList();

        // final messages = controller.getMsg(chatPath);
        // log('num of masseges: ${messages.length}');

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final senderId = messages[index].senderId;
            final sender = controller.getUserbyId(senderId);
            final senderImage = sender.image;
            final senderName = sender.name;
            final msg = messages[index].text;
            final isMyMessage = controller.myUser.uid == senderId ? true : false;
            final type = messages[index].type.name;
            final timeSent = Utils.formatDate((messages[index].timeSent));

            switch (type) {
              case 'text':
                return MessageBubble(
                  username: senderName,
                  userImage: senderImage,
                  textMessage: msg!,
                  isMyMessage: isMyMessage,
                  isSequenceOfMessages: false,
                  timeSent: timeSent,
                );
              case 'photo':
                return ImageMessageBubble(
                  timeSent: timeSent,
                  username: senderName,
                  isMyMessage: isMyMessage,
                  image: File(messages[index].image!),
                  text: msg,
                );

              case 'video':
                return VideoMessageBubble(
                  video: File(messages[index].video!),
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
                        audioSrc: messages[index].audio!,
                        contactBgColor: isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor,

                        //  played: true, // To show played badge or not.
                        me: isMyMessage, // Set message side.
                        onPlay: () {}, // Do something when voice played.
                      ),
                    ),
                  ],
                );

              default:
                log('Message type: $type');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(child: Text('unknown message type')),
                    ),
                  ],
                );
            }
          },
        );
      },
    );
  }
}
