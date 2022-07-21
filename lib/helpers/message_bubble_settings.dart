import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dao/dao.dart';

enum ChatBacground {
  color,
  image,
}

class MessageBubbleSettings {
  static RxInt fontSize = Dao.getMessageFontSize().obs;
  static final RxString _chatBackgroundImage = Dao.getChatBackground().obs;
  static final _backgroundType = Dao.getBackgroundType().obs;

  static List<String> backgroundImages = [
    'assets/chat_background_light.png',
    'assets/chat_background_black.jpg',
    'assets/chat_background_dark_blue.png',
  ];

  static setFontSize(int newValue) async {
    fontSize.value = newValue;
    Dao.setMessageFontSize(newValue);
  }

  static Rx<ChatBacground> get backgroundType => _backgroundType;

  static setchatBackgroundType(ChatBacground type) async {
    _backgroundType.value = type;
    Dao.setBackgroundType(type);
  }

  static RxString get chatBackgroundImage => _chatBackgroundImage;

  static setchatBackgroundImage(String imagePath) async {
    chatBackgroundImage.value = imagePath;
    Dao.setBackgroundType(ChatBacground.image);
    Dao.setChatBackground(imagePath);
  }

  static Color myMessageColor = Colors.blue;
  // Color(0xff2176FF);
  //Colors.green;
  static Color othersMessageColor = Colors.white;
}
