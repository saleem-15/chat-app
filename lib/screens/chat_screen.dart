import 'package:chat_app/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/message_bubble_settings.dart';
import '../widgets/chat_text_field.dart';
import 'user_details_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    required this.name,
    required this.image,
    required this.chatPath,
    super.key,
  });

  final String chatPath;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Get.to(() => UserDetailsScreen(
                  name: name,
                  image: image,
                ));
          },
          child: Row(
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
        ),
        actions: const [Icon(Icons.more_vert)],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            MessageBubbleSettings.chatBackgroundImage.value,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Expanded(
                  child: Messages(
                chatPath: chatPath,
              )),
              ChatTextField(
                chatPath: chatPath,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
