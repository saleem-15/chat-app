import 'dart:io';

import 'package:chat_app/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

//--------------------------------------------------------------------------
  Future<void> getMyChats() async {
    var chats = await FirebaseApi.getMyChats();

    myChatsList.clear();
    for (var chat in chats) {
      myChatsList.add(chat.obs);
    }

    update();

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

  Future<void> createGroupChat(String groupName, List<String> membersIds, File? image) async {
    final imageId = Timestamp.now().toString();

    if (image != null) {
      final imageRef = FirebaseStorage.instance.ref().child('chats').child('$imageId.jpg');

      await imageRef.putFile(image).whenComplete(() => null);

      final imageUrl = await imageRef.getDownloadURL();
      final groupId = await FirebaseApi.createGroupChat(groupName, membersIds, imageUrl);
    } else {
      //
    }

    return;
  }

  Future<MyUser> getUserbyId(String userID) async {
    return FirebaseApi.getUserbyId(userID);
  }

  Future<Chat> getGroupChatbyId(String groupId) async {
    return await FirebaseApi.getGroupData(groupId);
  }
}
