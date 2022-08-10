import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controllers/controller.dart';

void showMyQrDialog(BuildContext context) {
    final myId = Get.find<Controller>().myUser.uid;
    final myName = Get.find<Controller>().myUser.name;
    final myEmail = FirebaseAuth.instance.currentUser!.email!;

    final data = 'Email:$myEmail/$myId';

    Get.defaultDialog(
      title: myName,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 200,
        height: 200,
        color: Colors.white,
        child: QrImage(
          data: data,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }