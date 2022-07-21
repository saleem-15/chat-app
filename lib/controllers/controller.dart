import 'dart:io';
import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../dao/dao.dart';
import '../dao/files_manager.dart';
import '../models/chat.dart';
import '../models/user.dart';

class Controller extends GetxController {
  Controller() {
    if (!db.isDataInitilizedFromBackend) {
      intilizeDataFromBackend();
    } else {
      initilizeData();
    }
  }

  Dao get db => Dao.instance;
  FileManager get files => FileManager.instance;

  var myChatsList = <Rx<Chat>>[].obs;

  late final MyUser myUser;

  String? _username;
  String? email = FirebaseAuth.instance.currentUser?.email!;

  Future<void> intilizeDataFromBackend() async {
    //get data from back end
    final chats = await FirebaseApi.getMyChats();

    myUser = await FirebaseApi.getUserData();
    db.setUserData(myUser);

    //store the data in the database
    db.addListOfChats(chats);

    //add the data to the list of chats
    addListOfChats(chats);

    //write in the db that data is initialized
    db.setDataIsInitializedFromBackend();

    update();
  }

  void addListOfChats(List<Chat> list) {
    for (var chat in list) {
      myChatsList.add(chat.obs);
    }
  }

//--------------------------------------------------------------------------
  Future<void> initilizeData() async {
    myUser = db.getUserData();

    var chats = db.getAllChats();

    for (var chat in chats) {
      myChatsList.add(chat.obs);
    }

    update();

    //return [model.MyUser(name: 'saleem',chatId: '',image: '',uid: '')];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatPath) {
    final stream = FirebaseApi.getMessages(chatPath);

    stream.listen((event) {
      final messages = [];

      for (var docChange in event.docChanges) {
        final msgDoc = docChange.doc;
        switch (docChange.type) {
          case DocumentChangeType.added:
            break;

          case DocumentChangeType.modified:
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
    });
    return stream;
  }

  List<Message> getMsg(String chatPath) {
    final chat = myChatsList.firstWhere((chat) => chat.value.chatPath == chatPath);

    final messages = chat.value.messages;

    final stream = FirebaseApi.getMessages(chatPath);
    stream.listen((event) {
      final messages = [];

      for (var docChange in event.docChanges) {
        final msgDoc = docChange.doc;
        switch (docChange.type) {
          case DocumentChangeType.added:
            break;

          case DocumentChangeType.modified:
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
    });

    return messages;
  }

  void addMessage(Message msg) {
    db.addMessage(msg);
  }

  void sendMessage(String msg, String chatPath) async {
    FirebaseApi.sendMessage(msg, chatPath, myUser.name, myUser.image);
  }

  Future<void> addNewContact(MyUser user) async {
    final chatPath = await FirebaseApi.addNewContact(user.uid);

    user.chatId = Utils.getdocId(chatPath);

    final chat = Chat(name: user.name, image: user.image, chatPath: chatPath, userId: user.uid);

    db.addChat(chat);

    return;
  }

  Future<void> createGroupChat(String groupName, List<String> membersIds, File? image) async {
    final imageId = Timestamp.now().toString();

    if (image != null) {
      final imageRef = FirebaseStorage.instance.ref().child('chats').child('$imageId.jpg');

      await imageRef.putFile(image).whenComplete(() => null);

      final imageUrl = await imageRef.getDownloadURL();
      final groupPath = await FirebaseApi.createGroupChat(groupName, membersIds, imageUrl);

      final chatGroup = Chat.group(name: groupName, image: imageUrl, chatPath: groupPath);
      myChatsList.add(chatGroup.obs); //add to the list of chats

      db.addChat(chatGroup); //add to the database
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

  void sendPhoto(Message image) {
    files.saveImageToFile(image.image!, image.chatPath);
    FirebaseApi.sendPhoto(image, myUser.name, myUser.image);
  }

  void sendVideo(Message video) {
    FirebaseApi.sendVideo(video, myUser.name, myUser.image);
  }

  void sendAudio(Message audio) {
    FirebaseApi.sendAudio(audio, myUser.name, myUser.image);
  }
}
