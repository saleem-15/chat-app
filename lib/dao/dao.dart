import 'package:chat_app/helpers/message_bubble_settings.dart';
import 'package:chat_app/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/chat.dart';
import '../models/user.dart';

class Dao {
  Dao() {
    // myBox.clear();
    // chatsBox.clear();
  }

  static final _instance = Dao();
  static Dao get instance => _instance;

  static late final Box<Chat> chatsBox;
  static late final Box myBox;

  void addMessage(Message msg) {
    final updatedChat = getChat(msg.chatPath)..messages.add(msg);
    chatsBox.put(msg.chatPath, updatedChat);
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

  static void setBackgroundType(ChatBacground backgroundType) {
    myBox.put('chat_background_type', backgroundType);
  }

  static ChatBacground getBackgroundType() {
    return myBox.get('chat_background_type', defaultValue: ChatBacground.image);
  }
}
