// ignore_for_file: must_be_immutable

import 'package:chat_app/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTextField extends StatelessWidget {
  ChatTextField({required this.chatId, super.key});

  final chatId;

  final _controller = TextEditingController();
  var text = ''.obs;

  @override
  Widget build(BuildContext context) {
    final getController = Get.find<Controller>();
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
        child: TextField(
          minLines: 1,
          maxLines: 5,
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20, top: 15),
            border: InputBorder.none,
            hintText: 'Message',
            fillColor: Colors.red,
            prefixIcon: IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: () {},
            ),
            suffixIcon: text.isEmpty
                ? IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: const Icon(Icons.camera_alt_rounded),
                    onPressed: () {},
                  )
                : IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: () {
                      getController.sendMessage(_controller.text.trim(), chatId);
                      _controller.clear();
                    },
                  ),
          ),
          onChanged: (value) => text.value = value,
        ),
      ),
    );
  }
}
