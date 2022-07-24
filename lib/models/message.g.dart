// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 2;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      type: fields[4] as MessageType,
      chatPath: fields[0] as String,
      text: fields[3] as String?,
      senderId: fields[1] as String,
    )
      ..image = fields[5] as String?
      ..video = fields[6] as String?
      ..audio = fields[7] as String?
      ..file = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.chatPath)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.timeSent)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.video)
      ..writeByte(7)
      ..write(obj.audio)
      ..writeByte(8)
      ..write(obj.file);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
