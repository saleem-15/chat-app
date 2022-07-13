import 'package:chat_app/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/chat.dart';
import '../models/user.dart';

class Controller extends GetxController {
  Controller() {
    getUserData();
  }
  var myChatsList = <Rx<Chat>>[].obs;

  late final MyUser user;

  String? _username;
  final String email = FirebaseAuth.instance.currentUser!.email!;

  Future<void> getUserData() async {
    user = await FirebaseApi.getUserData();
  }

  Future<String> getUsername() async {
    _username ??= user.name;

    return _username!;
  }

  Future<void> getMyChats() async {
    var chats = await FirebaseApi.getMyChats();

    myChatsList.clear();
    for (var chat in chats) {
      myChatsList.add(chat.obs);
    }

    //return [model.MyUser(name: 'saleem',chatId: '',image: '',uid: '')];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return FirebaseApi.getMessages(chatId);
  }

  void sendMessage(String msg, String chatId) async {
    FirebaseApi.sendMessage(msg, chatId, user.name, user.image);
  }

  Future<void> addNewChat(String contactId) async {
    await FirebaseApi.addNewContact(contactId);

    return;
  }

  Future<MyUser> getUserbyId(String userID) async {
    return FirebaseApi.getUserbyId(userID);
  }
}
