import 'package:chat_app/helpers/message_bubble_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_viewer/video_viewer.dart';

import '../screens/video_viewer_screen.dart';

class VideoMessageBubble extends StatelessWidget {
  VideoMessageBubble({
    Key? key,
    required this.videoUrl,
    this.text,
    required this.isMyMessage,
  }) : super(key: key);

  final String videoUrl;
  final String? text;
  final bool isMyMessage;
  final controller = VideoViewerController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();

            Get.to(() => VideoViewerScreen(
                  videoUrl: videoUrl,
                ));
          },
          child: Container(
            margin: EdgeInsets.only(
              right: isMyMessage ? 8 : 0,
              left: isMyMessage ? 0 : 8,
              bottom: 5,
              top: 3,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Hero(
                    tag: videoUrl,
                    child: VideoViewer(
                      controller: controller,
                      source: {
                        "SubRip Text": VideoSource(
                          video: VideoPlayerController.network(videoUrl),
                        )
                      },
                    ),
                  ),
                ),
                if (text != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(text!),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
