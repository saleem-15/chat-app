import 'package:get/get.dart';

import '../../../api/firebase_api.dart';
import '../../../controllers/controller.dart';
import '../../../models/user.dart';

Future<MyUser?> findUserById(String id) async {
  final MyUser? user = await FirebaseApi.findUserById(id);

  return user;
}

Future<MyUser?> findUserByEmail(String email) async {
  final MyUser? user = await FirebaseApi.findUserByEmail(email);

  return user;
}

bool findIsMyContactById(String id) {
  bool isMyContact = false;
  final chatsList = Get.find<Controller>().myChatsList;

  for (var chat in chatsList) {
    final isGroup = chat.value.isGroupChat;

    if (isGroup) {
      continue;
    }

    final contactId = chat.value.usersIds.first;
    if (contactId == id) {
      isMyContact = true;
    }
  }

  return isMyContact;
}

bool findisMyContactByEmail(String email) {
  bool isMyContact = false;

  return isMyContact;
}
