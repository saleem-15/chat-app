import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/screens/add_new_contact/screens/add_new_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_new_group/screens/add_new_group_screen.dart';
import '../../chat_settings.dart';
import '../service/show_qr_code.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var name = Get.find<Controller>().myUser.name.obs;
    final image = Get.find<Controller>().myUser.image;
    return Drawer(
      backgroundColor: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DrawerHeader(image: image, name: name),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  //list item
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AddNewGroupScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 18,
                          top: 12,
                          bottom: 12,
                        ),
                        width: double.infinity,
                        child: Row(
                          children: const [
                            Icon(Icons.people),
                            SizedBox(
                              width: 15,
                            ),
                            Text('New Group'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const AddNewContactScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 18,
                          top: 12,
                          bottom: 12,
                        ),
                        width: double.infinity,
                        child: Row(
                          children: const [
                            Icon(Icons.person_add),
                            SizedBox(
                              width: 15,
                            ),
                            Text('New contact'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const ChatSettings());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 18,
                          top: 12,
                          bottom: 12,
                        ),
                        width: double.infinity,
                        child: Row(
                          children: const [
                            Icon(Icons.settings),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Chat Settings'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final RxString name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 53, right: 7, left: 18, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: FileImage(File(image)),
              ),
              IconButton(
                icon: const Icon(Icons.nightlight_outlined),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.value,
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => showMyQrDialog(context),
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
