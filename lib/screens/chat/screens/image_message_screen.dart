// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageMessageScreen extends StatelessWidget {
  const ImageMessageScreen({
    Key? key,
    required this.image,
    required this.senderName,
    required this.timeSent,
  }) : super(key: key);

  final File image;
  final String senderName;
  final String timeSent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              timeSent,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Center(
        child: Hero(
          tag: image.path,
          child: ExtendedImage.file(
            image,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
          ),
        ),
      ),
    );
  }
}
