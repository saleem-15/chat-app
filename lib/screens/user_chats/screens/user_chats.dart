import 'package:chat_app/screens/user_chats/components/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controller.dart';
import '../components/drawer.dart';

class UserChats extends StatelessWidget {
  const UserChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
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
              //
              final chat = myChats[index].value;

              return chat.isGroupChat
                  ? Column(
                      children: [
                        ChatTile(chatPath: chat.chatPath),
                        const Divider(
                          height: 0,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ChatTile.user(
                          userId: chat.usersIds[0],
                          chatPath: chat.chatPath,
                        ),
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
