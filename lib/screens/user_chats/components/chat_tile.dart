// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/screens/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../models/message_type.dart';

class ChatTile extends StatelessWidget {
  ChatTile({
    this.isGroupChat = true,
    required this.chatPath,
    super.key,
  });

  ChatTile.user({
    this.isGroupChat = false,
    required this.userId,
    required this.chatPath,
    super.key,
  });

  // (In case of group chat) userId = null
  String? userId;
  final String chatPath;
  late String image;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (controller) {
        //
        late final String name;
        if (isGroupChat) {
          final group = controller.getGroupChatbyId(chatPath);
          image = group.image;
          name = group.name;
        } else {
          final user = controller.getUserbyId(userId!);
          name = user.name;
          image = user.image;
        }

        return ListTile(
          onTap: () {
            Get.to(
              () => ChatScreen(chatPath: chatPath, image: image, name: name, userId: userId),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: FileImage(File(image)),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Text(
                '505',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Obx(() {
              final chat = controller.myChatsList.firstWhere((chat) => chat.value.chatPath == chatPath);
              final messagesList = chat.value.messages;

              log('messages: ${chat.value.messages.length}');
              if (messagesList.isEmpty) {
                return const SizedBox.shrink();
              }

              final lastMessage = chat.value.messages.last;
              switch (lastMessage.type) {
                case MessageType.text:
                  return Text(lastMessage.text!);

                case MessageType.photo:
                  return Row(
                    children: const [
                      Icon(
                        Icons.photo,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text('Photo'),
                    ],
                  );

                case MessageType.video:
                  return Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.video,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text('Video'),
                    ],
                  );

                case MessageType.audio:
                  return Row(
                    children: const [
                      Icon(
                        Icons.mic,
                        size: 18,
                      ),
                      Text('Audio'),
                    ],
                  );

                default:
                  return Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.solidFile,
                        size: 15,
                      ),
                      Text('File'),
                    ],
                  );
              }
            }),
          ),
        );
      },
    );
  }
}
