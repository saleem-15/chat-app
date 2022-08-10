import 'dart:developer';

import 'package:chat_app/storage/files_manager.dart';
import 'package:chat_app/helpers/message_bubble_settings.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/chat.dart';
import '../models/message_type.dart';
import '../models/user.dart';

class Dao {
  Dao() {
    // printChatBoxData();
  }

  // clearData() async {
  //   await myBox.clear();
  //   await chatsBox.clear();
  // }

  static final _instance = Dao();
  static Dao get instance => _instance;

  static late final Box<Chat> chatsBox;
  static late final Box myBox;

  Future<void> addMessage(Message msg) async {
    final chat = getChat(msg.chatPath);
    if (chat.messages.contains(msg)) {
      log('message already exists!! ---Hive did not save it again');
      return;
    }

    switch (msg.type) {
      case MessageType.photo:
        // if the message is an image then save it in the files
        // and store the path of the image in the database
        final imageFilePath = await FileManager.instance.saveFileFromNetwork(msg.image!, msg.chatPath);
        msg.image = imageFilePath;
        break;

      case MessageType.video:
        final videoFilePath = await FileManager.instance.saveFileFromNetwork(msg.video!, msg.chatPath);
        msg.video = videoFilePath;

        break;

      case MessageType.audio:
        final audioFilePath = await FileManager.instance.saveFileFromNetwork(msg.audio!, msg.chatPath);
        msg.audio = audioFilePath;

        break;

      case MessageType.file:
        final filePath = await FileManager.instance.saveFileFromNetwork(msg.file!, msg.chatPath);
        msg.file = filePath;

        break;
      default:
    }

    chat.messages.add(msg);
    chatsBox.put(msg.chatPath, chat);
  }

  List<Chat> getAllChats() {
    var c = chatsBox.values.toList();

    return c;
  }

  void addListOfChats(List<Chat> list) async {
    for (var chat in list) {
      chatsBox.put(chat.chatPath, chat);
    }
  }

  Future<void> addChat(Chat chat) async {
    return await chatsBox.put(chat.chatPath, chat);
  }

  Chat getChat(String chatPath) {
    return chatsBox.get(chatPath)!;
  }

  Future<void> deleteChat(String id) async {
    return await chatsBox.delete(id);
  }

  void setUserData(MyUser user) {
    myBox.put('myName', user.name);
    myBox.put('myImage', user.image);
    myBox.put('myUid', user.uid);
  }

  MyUser getUserData() {
    final name = myBox.get('myName');
    final image = myBox.get('myImage');
    final uid = myBox.get('myUid');

    final me = MyUser(name: name, image: image, uid: uid, chatId: 'none');

    return me;
  }

  void setDataIsInitializedFromBackend() {
    myBox.put('is_data_initilized_from_backend', true);
  }

  bool get isDataInitilizedFromBackend {
    return myBox.get('is_data_initilized_from_backend', defaultValue: false);
  }

  static setMessageFontSize(int newValue) {
    myBox.put('message_font_size', newValue);
  }

  static int getMessageFontSize() {
    return myBox.get('message_font_size', defaultValue: 16) as int;
  }

  static void setChatBackground(String imagePath) {
    myBox.put('chat_background', imagePath);
  }

  static String getChatBackground() {
    return myBox.get('chat_background', defaultValue: MessageBubbleSettings.backgroundImages[0]);
  }

  static void setChatBackgroundColor(Color color) {
    myBox.put('chat_background_color', color.value);
  }

  static Color getChatBackgroundColor() {
    final colorValue = myBox.get('chat_background_color', defaultValue: Colors.white.value);
    return Color(colorValue);
  }

  static void setBackgroundType(ChatBacground backgroundType) {
    myBox.put('chat_background_type', backgroundType.name);
  }

  static ChatBacground getBackgroundType() {
    final chatBacgroundType = myBox.get('chat_background_type', defaultValue: ChatBacground.image.name);
    if (chatBacgroundType == 'image') {
      return ChatBacground.image;
    } else {
      return ChatBacground.color;
    }
  }

  static void printChatBoxData() {
    log('Chats stored in the Databas:');

    final chats = chatsBox.values.toList();
    for (var chat in chats) {
      log(chat.name);
      for (var message in chat.messages) {
        log(message.text!);
      }
    }
  }
}
