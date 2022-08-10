import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickedPhotoViewer extends StatelessWidget {
  PickedPhotoViewer({
    Key? key,
    required this.image,
    required this.sendImage,
  }) : super(key: key);

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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      //Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
                    child: TextField(
                      minLines: 1,
                      maxLines: 4,
                      controller: _textController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
                        border: InputBorder.none,
                        hintText: 'Add a caption',
                        fillColor: Colors.red,
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  //send button
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final message = _textController.text.trim();

                        sendImage(
                          image,
                          message.isEmpty ? null : message,
                        );

                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: TextFormField(
            //     controller: _textController,
            //     style: const TextStyle(color: Colors.white),
            //     decoration: InputDecoration(
            //       isCollapsed: true,
            //       suffixIcon: IconButton(
            //         icon: const Icon(Icons.send),
            //         onPressed: () {
            //           final message = _textController.text.trim();

            //           sendImage(
            //             image,
            //             message.isEmpty ? null : message,
            //           );

            //           Get.back();
            //         },
            //       ),
            //       filled: true,
            //       fillColor: Colors.black26,
            //       hintText: 'Add a caption',
            //       hintStyle: const TextStyle(color: Colors.grey),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
