// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

enum MessageType {
  text,
  photo,
  video,
  audio,
  file,
}

class Message {
  final String chatPath;

  final String? text;

  final MessageType type;

  File? image;

  File? video;

  File? audio;

  File? file;

  Message({
    required this.chatPath,
    required this.text,
    required this.type,
  });

  Message.image({
    required this.chatPath,
    this.text,
    this.type = MessageType.photo,
    required this.image,
  });

  Message.video({
    required this.chatPath,
    this.text,
    this.type = MessageType.video,
    required this.video,
  });

  Message.file({
    required this.chatPath,
    this.text,
    this.type = MessageType.file,
    required this.file,
  });

  Message.audio({
    required this.chatPath,
    this.text,
    this.type = MessageType.audio,
    required this.audio,
  });
}
