// ignore_for_file: must_be_immutable

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTile extends StatelessWidget {
  ChatTile({required this.chatId, required this.image, super.key});

  ChatTile.user({required this.userId, required this.chatId, required this.image, super.key});

  // (In case of group chat) userId = null
  String? userId;
  final String chatId;
  final String image;

  @override
  Widget build(BuildContext context) {
    final isUser = userId != null ? true : false;

    return GetBuilder<Controller>(
      builder: (controller) {
        return FutureBuilder(
          future: isUser ? controller.getUserbyId(userId!) : controller.getGroupChatbyId(chatId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = snapshot.data ?? MyUser(name: 'saleem', image: '', uid: '');

            return ListTile(
              onTap: () {
                Get.to(() => ChatScreen(chatId: chatId, image: user.image, name: user.name));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(image),
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
              subtitle: const Text('this is last message'),
            );
          },
        );
      },
    );
  }
}
