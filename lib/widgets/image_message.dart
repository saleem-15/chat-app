import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chat_app/helpers/message_bubble_settings.dart';
import 'package:get/get.dart';

import '../screens/image_message_screen.dart';

class ImageMessageBubble extends StatelessWidget {
  const ImageMessageBubble({
    Key? key,
    required this.image,
    this.text,
    required this.timeSent,
    required this.username,
    required this.isMyMessage,
  }) : super(key: key);

  final File image;
  final String? text;
  final String timeSent;
  final String username;
  final bool isMyMessage;
  final double borderRadius = 15;

  @override
  Widget build(BuildContext context) {
    var fontSize = MessageBubbleSettings.fontSize;

    return Row(
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            //to remove the keyboaed (better animation)
            FocusScope.of(context).unfocus();

            // showImageViewer(context, FileImage(image), onViewerDismissed: () {
            //   print("dismissed");
            // });
            Get.to(() => ImageMessageScreen(
                  image: image,
                  senderName: username,
                  timeSent: timeSent,
                ));
          },
          child: Container(
            width: 300,
            margin: EdgeInsets.only(
              right: isMyMessage ? 8 : 0,
              left: isMyMessage ? 0 : 8,
              bottom: 5,
              top: 3,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
              color: isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMyMessage)
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 8, top: 3),
                    child: Text(
                      username,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                Stack(
                  children: [
                    Hero(
                      tag: image.hashCode,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Image.file(
                          image,

                          /// this code is for Image.network
                          // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          //   return Center(child: child);
                          // },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 8,
                      child: Text(
                        timeSent,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                if (text != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Text(
                      text!,
                      style: TextStyle(fontSize: fontSize.value.toDouble()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
