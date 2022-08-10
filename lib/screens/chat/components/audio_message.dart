// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../helpers/message_bubble_settings.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({
    Key? key,
    required this.isMyMessage,
    required this.audioPath,
    required this.timeSent,
  }) : super(key: key);

  final bool isMyMessage;
  final String audioPath;
  final String timeSent;

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: [
              VoiceMessage(
                audioSrc: audioPath,
                contactBgColor: isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor,

                //  played: true, // To show played badge or not.
                me: isMyMessage, // Set message side.
                onPlay: () {}, // Do something when voice played.
              ),
              Positioned(
                bottom: 2,
                right: 5,
                child: Text(
                  timeSent,
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
