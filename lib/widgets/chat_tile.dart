// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTile extends StatelessWidget {
  ChatTile({
    required this.chatPath,
    required this.image,
    super.key,
  });

  ChatTile.user({
    required this.userId,
    required this.chatPath,
    required this.image,
    super.key,
  });

  // (In case of group chat) userId = null
  String? userId;
  final String chatPath;
  final String image;

  @override
  Widget build(BuildContext context) {
    final isUser = userId != null ? true : false;

    return GetBuilder<Controller>(
      builder: (controller) {
        return FutureBuilder(
          future: isUser ? controller.getUserbyIdFromBackend(userId!) : controller.getGroupChatbyId(chatPath),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            ///
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = snapshot.data ?? MyUser(name: 'saleem', image: '', uid: '');

            return ListTile(
              onTap: () {
                Get.to(() => ChatScreen(chatPath: chatPath, image: image, name: user.name, userId: userId));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: FileImage(File(image)),
              ),
              title: Text(
                user.name,
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
              // subtitle: Obx(() {
              //   final chat = Get.find<Controller>().myChatsList.firstWhere((chat) => chat.value.chatPath == chatPath);
              //   log('messages: ${chat.value.messages.length}');
              //   final lastMessage = chat.value.messages[chat.value.messages.length];
              //   switch (lastMessage.type) {
              //     case MessageType.text:
              //       return Text(lastMessage.text!);

              //     case MessageType.photo:
              //       return Row(
              //         children: const [
              //           Icon(
              //             Icons.photo,
              //             size: 10,
              //           ),
              //           Text('Photo'),
              //         ],
              //       );

              //     case MessageType.video:
              //       return Row(
              //         children: const [
              //           FaIcon(
              //             FontAwesomeIcons.video,
              //             size: 10,
              //           ),
              //           Text('Video'),
              //         ],
              //       );

              //     case MessageType.audio:
              //       return Row(
              //         children: const [
              //           Icon(
              //             Icons.mic,
              //             size: 10,
              //           ),
              //           Text('Audio'),
              //         ],
              //       );

              //     default:
              //       return Row(
              //         children: const [
              //           FaIcon(
              //             FontAwesomeIcons.solidFile,
              //             size: 10,
              //           ),
              //           Text('File'),
              //         ],
              //       );
              //   }
              // }),
            );
          },
        );
      },
    );
  }
}
