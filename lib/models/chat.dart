import 'dart:convert';

import 'package:chat_app/helpers/utils.dart';
import 'package:hive/hive.dart';

import 'message.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
part 'hive  adapters/chat.g.dart';

@HiveType(typeId: 1)
class Chat {
  /// if the chat is for a user then only one element in the list .
  /// if its for a group then there is multiple elements
  @HiveField(0)
  List<String> usersIds;

  // (user name) Or (group name)
  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  @HiveField(3)
  String chatPath;

  @HiveField(4)
  final bool isGroupChat;

  @HiveField(5)
  late List<Message> messages = [];

  Chat({
    required this.usersIds,
    required this.name,
    required this.image,
    required this.chatPath,
    this.isGroupChat = false,
  });

  Chat.group({
    required this.usersIds,
    required this.name,
    required this.image,
    required this.chatPath,
    this.isGroupChat = true,
  });

  Map<String, dynamic> toMap() {
    return isGroupChat
        ? <String, dynamic>{
            'name': name,
            'image': image,
            'chatPath': chatPath,
            'usersIds': usersIds,
          }
        : <String, dynamic>{
            'name': name,
            'image': image,
            'chatPath': chatPath,
            'userId': usersIds[0],
          };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    final bool isGroup = Utils.getCollectionId(map['chatPath']) == 'Group_chats';

    return isGroup
        ? Chat.group(
            name: map['name'] as String,
            image: map['image'] as String,
            chatPath: map['chatPath'] as String,
            usersIds: map['usersIds'] as List<String>,
          )
        : Chat(
            name: map['name'] as String,
            image: map['image'] as String,
            chatPath: map['chatPath'] as String,
            usersIds: [map['userId'] as String],
          );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(userId: $usersIds, name: $name, image: $image, chatPath: $chatPath, isGroupChat: $isGroupChat)';
  }
}
