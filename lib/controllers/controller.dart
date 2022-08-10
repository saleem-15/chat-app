import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/helpers/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../storage/dao.dart';
import '../storage/files_manager.dart';
import '../models/chat.dart';
import '../models/user.dart';

class Controller extends SuperController {
  Controller();

  Timer? timer;
  Dao get db => Dao.instance;
  FileManager get fileManager => FileManager.instance;

  var myChatsList = <Rx<Chat>>[].obs;

  late final MyUser myUser;

  String? email = FirebaseAuth.instance.currentUser?.email!;

  void sendToServerThatIamOnline() {
    FirebaseApi.sendToServerThatIamOnline();
  }

  Future<void> intilizeDataFromBackend() async {
    //get data from back end
    final chats = await FirebaseApi.getMyChats();
    myUser = await FirebaseApi.getUserData();

    //store the data in the database
    await setUserData(myUser);

    await storeChatsInDatabase(chats);

    //add the data to the list of chats
    addListOfChats(chats);

    //write in the db that data is initialized
    db.setDataIsInitializedFromBackend();

    //open streams
    for (var chat in myChatsList) {
      getMessagesFromBackend(chat.value.chatPath);
    }

    //start sending to the server that I am online
    timer = Timer.periodic(
        const Duration(minutes: 1), (timer) => sendToServerThatIamOnline());

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
    //open streams
    for (var chat in myChatsList) {
      getMessagesFromBackend(chat.value.chatPath);
    }

    //start sending to the server that u are online
    timer = Timer.periodic(
        const Duration(minutes: 1), (timer) => sendToServerThatIamOnline());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesFromBackend(String chatPath) {
    final stream = FirebaseApi.getMessages(chatPath);

    stream.listen((event) async {
      for (var docChange in event.docChanges) {
        final msgDoc = docChange.doc;
        final message = messageFromDocument(msgDoc, chatPath);

        switch (docChange.type) {
          case DocumentChangeType.added:
            addMessage(await message);
            update();

            break;

          case DocumentChangeType.modified:
            updateMessage(await message);
            update();

            break;

          case DocumentChangeType.removed:
            update();

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
    stream.listen((event) async {
      for (var docChange in event.docChanges) {
        final msgDoc = docChange.doc;
        final message = messageFromDocument(msgDoc, chatPath);

        switch (docChange.type) {
          case DocumentChangeType.added:
            addMessage(await message);
            break;

          case DocumentChangeType.modified:
            updateMessage(await message);
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
    });

    return messages;
  }

  Future<Message> messageFromDocument(
      DocumentSnapshot<Map<String, dynamic>> msgDoc, String chatPath) async {
    late final Message message;

    switch (msgDoc['type']) {
      case 'text':
        message = Message(
            chatPath: chatPath, text: msgDoc['text'], senderId: msgDoc['senderId']);
        break;

      case 'image':
        final filePath =
            await FileManager.instance.saveFileFromNetwork(msgDoc['image'], chatPath);
        final image = File(filePath);
        message = Message.image(
            chatPath: chatPath,
            image: image.path,
            text: msgDoc['text'],
            senderId: msgDoc['senderId']);
        break;

      case 'video':
        final filePath =
            await FileManager.instance.saveFileFromNetwork(msgDoc['video'], chatPath);
        // log('video path: $filePath');
        final video = File(filePath);
        message = Message.video(
            chatPath: chatPath,
            video: video.path,
            text: msgDoc['text'],
            senderId: msgDoc['senderId']);
        break;

      case 'audio':
        final filePath =
            await FileManager.instance.saveFileFromNetwork(msgDoc['audio'], chatPath);
        // log('audio path: $filePath');
        final audioFile = File(filePath);
        message = Message.audio(
            chatPath: chatPath,
            audio: audioFile.path,
            text: msgDoc['text'],
            senderId: msgDoc['senderId']);
        break;
    }

    return message;
  }

  void addMessage(Message message) {
    final chat =
        myChatsList.firstWhere((chat) => chat.value.chatPath == message.chatPath);
    chat.value.messages.add(message);
    update();
    db.addMessage(message);
  }

  void updateMessage(Message message) {
    final chat =
        myChatsList.firstWhere((chat) => chat.value.chatPath == message.chatPath);
    final indexOfMessageToBeUpdated = chat.value.messages.indexWhere((msg) {
      if (msg == message) {
        // log('Message updated Succesfully');
        return true;
      } else {
        // log('Message IS NOT updated');

        return false;
      }
    });

    chat.value.messages[indexOfMessageToBeUpdated] = message;

    // db.updateMessage(message);
  }

  void sortChatMessages(String chatPath) {
    final chat = myChatsList.firstWhere((chat) => chat.value.chatPath == chatPath);
    chat.value.messages.sort((a, b) {
      return a.timeSent.millisecond.compareTo(b.timeSent.millisecond);
    });
  }

  Future<void> addNewContact(MyUser user) async {
    final chatPath = await FirebaseApi.addNewContact(user.uid);

    user.chatId = Utils.getdocId(chatPath);

    final chat = Chat(
        name: user.name, image: user.image, chatPath: chatPath, usersIds: [user.uid]);

    final imageFilePath =
        await fileManager.saveFileFromNetwork(chat.image, chat.chatPath);
    chat.image = imageFilePath;

    myChatsList.add(chat.obs);
    db.addChat(chat);

    update();
    return;
  }

  Future<void> createGroupChat(
      String groupName, List<String> membersIds, File image) async {
    final imageId = Timestamp.now().toString();

    /// upload the group image
    final imageRef = FirebaseStorage.instance.ref().child('chats').child('$imageId.jpg');
    await imageRef.putFile(image).whenComplete(() => null);
    final imageUrl = await imageRef.getDownloadURL();

    final groupPath = await FirebaseApi.createGroupChat(
        groupName, [myUser.uid, ...membersIds], imageUrl);
    final imageFilePath = await fileManager.saveFileFromNetwork(imageUrl, groupPath);

    final chatGroup = Chat.group(
        name: groupName, image: imageFilePath, chatPath: groupPath, usersIds: membersIds);
    myChatsList.add(chatGroup.obs); //add to the list of chats

    update();
    db.addChat(chatGroup); //add to the database

    return;
  }

  Future<MyUser> getUserbyIdFromBackend(String userID) async {
    return FirebaseApi.getUserbyId(userID);
  }

  void printChatsData() {
    for (var chat in myChatsList) {
      log('num of chats: ${myChatsList.length}');
      log('chat name: ${chat.value.name}');
      log('user id: ${chat.value.usersIds}');
      log('********************************');
    }
  }

  MyUser getUserbyId(String userID) {
    if (userID == myUser.uid) {
      return myUser;
    }
    //printChatsData();
    // log('user id: $userID');
    final chat = myChatsList.firstWhere(
        (chat) => !chat.value.isGroupChat && chat.value.usersIds[0] == userID);

    final userData = chat.value;
    return MyUser(
      image: userData.image,
      name: userData.name,
      uid: userID,
      chatId: userData.chatPath,
    );
  }

  Future<Chat> getGroupChatbyIdFromBackend(String groupId) async {
    return await FirebaseApi.getGroupData(groupId);
  }

  Chat getGroupChatbyId(String groupId) {
    final chat = myChatsList.firstWhere((chat) => chat.value.chatPath == groupId);
    return chat.value;
  }

  void sendMessage(String msg, String chatPath) async {
    FirebaseApi.sendMessage(msg, chatPath, myUser.name, myUser.image, Timestamp.now());
  }

  void sendPhoto(Message image) {
    fileManager.saveToFile(File(image.image!), image.chatPath);
    FirebaseApi.sendPhoto(image, myUser.name, myUser.image);
  }

  void sendVideo(Message video) {
    fileManager.saveToFile(File(video.video!), video.chatPath);

    FirebaseApi.sendVideo(video, myUser.name, myUser.image);
  }

  void sendAudio(Message audio) {
    fileManager.saveToFile(File(audio.audio!), audio.chatPath);

    FirebaseApi.sendAudio(audio, myUser.name, myUser.image);
  }

  Future<void> storeChatsInDatabase(List<Chat> chats) async {
    for (var chat in chats) {
      final imageFilePath =
          await fileManager.saveFileFromNetwork(chat.image, chat.chatPath);

      chat.image = imageFilePath;
      log('Controller => storeChatsInDatabase => image path: $imageFilePath');
    }
    db.addListOfChats(chats);
  }

  Future<void> setUserData(MyUser myUser) async {
    final imageFilePath = await fileManager.saveFileFromNetwork(myUser.image, 'myInfo');
    myUser.image = imageFilePath;
    db.setUserData(myUser);
  }

  Future<String> getLastTimeOnline(String userId) async {
    final timestamp = await FirebaseApi.getLastTimeOnline(userId);
    final lastOnline = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(lastOnline);

    if (now.day != lastOnline.day) {
      final lastSeen =
          '${DateFormat('MMM d').format(lastOnline)} at ${DateFormat(' h:mm a').format(lastOnline)}';

      return 'last seen $lastSeen';
    } else if (difference.inSeconds < 60) {
      //if it was (last_online) in the last  60 seconds
      log('difference in seconds: ${difference.inSeconds}');
      return 'Online';
    }
    return 'last seen at ${Utils.formatDate(lastOnline)}';
  }

  @override
  void onDetached() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  void onInactive() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  void onPaused() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  void onResumed() {
//start sending to the server that u are online
    timer = Timer.periodic(
        const Duration(minutes: 1), (timer) => sendToServerThatIamOnline());
  }

  List<MyUser> getGroupUsers(String groupId) {
    List<MyUser> users = [myUser]; // I am a member of the group
    final groupChat = myChatsList.firstWhere((chat) => chat.value.chatPath == groupId);

    for (var userId in groupChat.value.usersIds) {
      final user = getUserbyId(userId);
      users.add(user);
    }
    return users;
  }
}
