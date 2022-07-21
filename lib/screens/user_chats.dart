import 'package:chat_app/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../widgets/drawer.dart';

class UserChats extends StatelessWidget {
  const UserChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Chats'),
        actions: const [Icon(Icons.search)],
      ),
      body: GetBuilder<Controller>(
        builder: (controller) {
          final myChats = controller.myChatsList;

          if (myChats.isEmpty) {
            return const Center(
              child: Text('There is no chats'),
            );
          }
          return ListView.builder(
            itemCount: myChats.length,
            itemBuilder: (context, index) {
              final chatId = myChats[index].value.chatPath;
              final userId = myChats[index].value.userId;
              final image = myChats[index].value.image;

              return Column(
                children: [
                  ChatTile.user(userId: userId, chatPath: chatId, image: image),
                  const Divider(
                    height: 0,
                  ),
                ],
              );
            },
          );
        },
      ),
    );  
  }
}
