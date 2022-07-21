import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_viewer/video_viewer.dart';

class PickedVideoScreen extends StatelessWidget {
  PickedVideoScreen({
    Key? key,
    required this.video,
    required this.sendVideo,
  }) : super(key: key);

  final File video;
  final void Function(File video, String? message) sendVideo;

  final _textController = TextEditingController();

  final VideoViewerController controller = VideoViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VideoViewer(
              controller: controller,
              source: {
                "SubRip Text": VideoSource(
                  video: VideoPlayerController.file(video),
                )
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  isCollapsed: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final message = _textController.text.trim();

                      sendVideo(
                        video,
                        message.isEmpty ? null : message,
                      );

                      Get.back();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: 'Add a caption',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
