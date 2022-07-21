import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_viewer/video_viewer.dart';

class VideoViewerScreen extends StatelessWidget {
  VideoViewerScreen({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  final String videoUrl;
  final VideoViewerController controller = VideoViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
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
    );
  }
}
