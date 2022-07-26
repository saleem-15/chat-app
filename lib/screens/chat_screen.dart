import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_app/widgets/messages.dart';

import '../controllers/controller.dart';
import '../helpers/message_bubble_settings.dart';
import '../widgets/chat_text_field.dart';
import 'user_details_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatPath,
    required this.name,
    required this.image,
    required this.userId,
  }) : super(key: key);

  final String chatPath;
  final String name;
  final String image;
  final String? userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final timer = Timer.periodic(const Duration(seconds: 50), (timer) {
    Get.find<Controller>().update();
  });
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String? lastSeen;

  @override
  Widget build(BuildContext context) {
    final bool isGroupChat = Utils.getCollectionId(widget.chatPath) == 'Group_chats' ? true : false;
    Rx<ChatBacground> chatBackgroundType = MessageBubbleSettings.backgroundType;
    log('image path: ${widget.image}');
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Get.to(() => UserDetailsScreen(
                  name: widget.name,
                  image: widget.image,
                  chatPath: widget.chatPath,
                ));
          },
          child: Row(
            children: [
              Hero(
                tag: widget.image,
                child: CircleAvatar(
                  backgroundImage: FileImage(File(widget.image)),
                  maxRadius: 20,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  if (!isGroupChat)
                    GetBuilder<Controller>(
                      builder: (controller) => FutureBuilder(
                        future: controller.getLastTimeOnline(widget.userId!),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // if (lastSeen == null) {
                            return Text(
                              'Connecting ...',
                              style: TextStyle(color: Colors.grey[200], fontSize: 12),
                            );

                            // }
                            //    return Text(
                            //   lastSeen!,
                            //   style: TextStyle(color: Colors.grey[200], fontSize: 12),
                            // );
                          }

                          return Text(
                            snapshot.data,
                            style: TextStyle(color: Colors.grey[200], fontSize: 12),
                          );
                        },
                      ),
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
          Obx(
            () => Positioned.fill(
              child: chatBackgroundType.value == ChatBacground.image
                  ? Image.asset(
                      MessageBubbleSettings.chatBackgroundImage.value,
                      fit: BoxFit.cover,
                    )
                  : Ink(
                      color: MessageBubbleSettings.chatBackgroundColor.value,
                    ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Messages(
                  chatPath: widget.chatPath,
                ),
              ),
              ChatTextField(
                chatPath: widget.chatPath,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
