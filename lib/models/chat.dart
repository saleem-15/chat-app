import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chat {
  // (user name) Or (group name)
  String name;
  String image;
  String chatId;
  final bool isGroupChat;
  String? userId;

  Chat({
    this.isGroupChat = false,
    required this.name,
    required this.image,
    required this.chatId,
    required this.userId,
  });

  Chat.group({
    this.isGroupChat = true,
    required this.name,
    required this.image,
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'chatId': chatId,
      'userId': userId,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      name: map['name'] as String,
      image: map['image'] as String,
      chatId: map['chatId'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
