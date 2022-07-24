import 'package:hive_flutter/hive_flutter.dart';

part 'message_type.g.dart';
@HiveType(typeId: 3)
enum MessageType {
    @HiveField(0)
  text,

    @HiveField(1)
  photo,

    @HiveField(2)
  video,

    @HiveField(3)
  audio,

    @HiveField(4)
  file,
}