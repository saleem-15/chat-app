import 'package:chat_app/widgets/messages.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_text_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({required this.name, required this.image, required this.chatId, super.key});

  final String chatId;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              maxRadius: 20,
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.grey[200], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: const [Icon(Icons.more_vert)],
      ),
      body: Column(
        children: [
          Expanded(
              child: Messages(
            chatId: chatId,
          )),
          ChatTextField(chatId: chatId,),
        ],
      ),
    );
  }
}
