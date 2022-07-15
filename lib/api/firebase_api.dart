import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat.dart';
import '../models/user.dart';

class FirebaseApi {
  static final db = FirebaseFirestore.instance;

  static Future<MyUser> getUserData() async {
    final user = await db.collection('users').doc(myUid).get();

    return MyUser(
      chatId: '.....', // does not matter here
      name: user['username'],
      image: user['image_url'],
      uid: user.id, // id of the document = uid of the user
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatID) {
    return db
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  static String get myUid {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> addNewUser(String username, String uid, String email, String imageUrl) async {
    // the document id will be the uid of the user
    return await db.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'image_url': imageUrl,
      'user_chats': [],
    });
  }

  static Future<DocumentReference<Map<String, dynamic>>> sendMessage(String msg, String chatID, String username, String userImage) async {
    return await db.collection('chats').doc(chatID).collection('messages').add({
      'text': msg,
      'createdAt': Timestamp.now(),
      'senderId': myUid,
      'senderName': username,
      'senderImage': userImage,
    });
  }

  static Future<MyUser?> findUserByEmail(String userEmail) async {
    var user = await db.collection('users').where('email', isEqualTo: userEmail).get();

    if (user.docs.isEmpty) return null; // if there is no match

    return user.docs[0].exists // if there is a match return the first result (firebase returns a list of results)
        ? MyUser(
            chatId: await getChatId(user.docs[0].id),
            name: user.docs[0]['username'],
            image: user.docs[0]['image_url'],
            uid: user.docs[0].id, // id of the document = uid of the user
          )
        : null;
  }

  // static Future<void> addToUserChats(String contactUid) {
  //   // adds new contact to the user chats

  //   db.collection('users').doc(contactUid).update({
  //     // add me to the other person 'user_chats'
  //     "user_chats": FieldValue.arrayUnion([myUid])
  //   });

  //   return db.collection('users').doc(myUid).update({
  //     //add the user to my chats
  //     "user_chats": FieldValue.arrayUnion([contactUid])
  //   });
  // }

  static Future<String> addNewContact(String contactUid) async {
    // create chat document
    final chat = await db.collection('chats').add({
      'members': [
        myUid,
        contactUid,
      ],
    });

    //add the user to me as a new contact
    db.collection('users').doc(myUid).update({
      "user_chats": FieldValue.arrayUnion([chat.path])
    });

    // add me as a new contact to the other person
    db.collection('users').doc(contactUid).update({
      "user_chats": FieldValue.arrayUnion([chat.path])
    });

    //////  addToUserChats(chat.path);

    log('addToUserChats() UId of the new chat---->${chat.id}');
    return chat.id;
  }

  static Future<String?> getChatId(String contactUid) async {
    var user = await db.collection('chats').where('members', isEqualTo: contactUid).get();

    // if there is no existing chat => create a new chat
    if (user.docs.isEmpty) {
      return null;
      //create a new  chat document with timestamp as an id
      /*
      final newChatID = Timestamp.now().toString();
      await db.collection('chats').doc(newChatID).set({});

      log('getChatId() 1nd log **UId of the new chat---->$newChatID');

      return newChatID; //chat id for the new created document
      */

    }

    log('getChatId() 2nd log **UId of the new chat---->${user.docs[0].id}');

    return user.docs[0].id; //chat id for the existing chat document

    // return user.docs[0].exists
    //     ? User(
    //       chatId: user.docs[0],
    //         name: user.docs[0]['username'],
    //         image: user.docs[0]['image_url'],
    //         uid: user.docs[0].id, // id of the document = uid of the user
    //       )
    //     : null;
  }

  static Future<List<Chat>> getMyChats() async {
    List<Chat> myChats = [];
    List<MyUser> myChatsList = [];
    final myData = await db.collection('users').doc(myUid).get();

    var myChatsIDs = myData['user_chats'] as List; //returns a list of chat id's (not user id's)

    for (String chatPath in myChatsIDs) {
      log('chat path: $chatPath');
      final collectionName = chatPath.split('/')[0];
      final chatId = chatPath.split('/')[1];

      final myChat = await db.collection(collectionName).doc(chatId).get(); //returns the chat document
      final chatMembers = myChat['members'] as List;

      if (collectionName == 'chats') {
        //if Not a Group chat

        final firstUserID = chatMembers[0];
        final secondUserID = chatMembers[1];

        late final MyUser otherUser;

        //this if/else block returns the other users data as (MyUser)
        //becuase i dont want my own data, I want the other user data to be retrieved
        if (myUid == firstUserID) {
          otherUser = await getUserbyId(secondUserID);
          otherUser.chatId = myChat.id;
        } else if (myUid == secondUserID) {
          otherUser = await getUserbyId(firstUserID);
          otherUser.chatId = myChat.id;
        }
        final c = Chat(chatId: otherUser.chatId!, image: otherUser.image, name: otherUser.name, userId: otherUser.uid);

        myChats.add(c);

        myChatsList.add(otherUser);
        log('user_chat ---> name: ${otherUser.name}/ uid: ${otherUser.uid}/ chatId: ${otherUser.chatId}');
      } else {
        //if group chat

        final c = await getGroupData(chatId);

        myChats.add(c);
      }
    }

    return myChats;

    //return myChatsList;

    //return [MyUser(name: 'saleem',chatId: '',image: '',uid: '')];
  }

  static Future<MyUser> getUserbyId(String userId) async {
    final user = await db.collection('users').doc(userId).get();

    return MyUser(
      chatId: '.....', // does not matter here
      name: user['username'],
      image: user['image_url'],
      uid: user.id, // id of the document = uid of the user
    );
  }

  static Future<Chat> getGroupData(String groupId) async {
    final groupDoc = await db.collection('Group_chats').doc(groupId).get();

    return Chat.group(name: groupDoc['group_name'], image: groupDoc['image'], chatId: groupId);
  }

  static Future<String> getUsername() async {
    final x = await getUserbyId(myUid);
    return x.name;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> messagesCollectionGroup()  {
    return  db.collectionGroup('messages').snapshots();
  }

  static Future<String> createGroupChat(String groupName, List<String> membersIds, String imageUrl) async {
    // create group chat document
    final chat = await db.collection('Group_chats').add({
      'group_name': groupName,
      'image': imageUrl,
      'members': [
        myUid,
        ...membersIds,
      ],
    });
    //add the created group to the "user_chats" for all the members of the group
    for (var id in membersIds) {
      db.collection('users').doc(id).update({
        "user_chats": FieldValue.arrayUnion([chat.path])
      });
    }

    return chat.id;
  }

  // try {
  //   log(myChats[0]);
  // } on FirebaseException catch (e) {
  //   print(e.stackTrace);
  // }

  // db.collection('users').doc(myUid).get().then((querySnapshot) => {
  //       // querySnapshot.forEach((doc) => {
  //       //     log(`${doc.id} => ${doc.data()}`);

  //       // }
  //       log('${querySnapshot.metadata}')
  //     });
}
