import 'dart:convert';

import 'package:hive/hive.dart';

import 'message.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
part 'chat.g.dart';

@HiveType(typeId: 1)
class Chat {
  //if the chat is for a user
  @HiveField(0)
  String? userId;

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
  List<Message> messages = [];

  Chat({
    this.isGroupChat = false,
    required this.name,
    required this.image,
    required this.chatPath,
    required this.userId,
  });

  Chat.group({
    this.isGroupChat = true,
    required this.name,
    required this.image,
    required this.chatPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'chatPath': chatPath,
      'userId': userId,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      name: map['name'] as String,
      image: map['image'] as String,
      chatPath: map['chatPath'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(userId: $userId, name: $name, image: $image, chatPath: $chatPath, isGroupChat: $isGroupChat)';
  }
}
