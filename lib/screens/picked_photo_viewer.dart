import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickedPhotoViewer extends StatelessWidget {
  PickedPhotoViewer({required this.image, super.key, required this.sendImage});

  final File image;
  final void Function(File image, String? message) sendImage;
  final _textController = TextEditingController();

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
            InteractiveViewer(
              child: Image.file(image),
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

                      sendImage(
                        image,
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
