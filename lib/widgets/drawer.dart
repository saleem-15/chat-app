import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/screens/add_new_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/add_new_group_screen.dart';
import '../screens/chat_settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var name = Get.find<Controller>().myUser.name.obs;
    final image = Get.find<Controller>().myUser.image;
    return Drawer(
      backgroundColor: Colors.blue,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, right: 7, left: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
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
                Obx(
                  () => Text(
                    name.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(children: [
                //list item
                InkWell(
                  onTap: () {
                    Get.to(() => AddNewGroupScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 10,
                      bottom: 10,
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
                InkWell(
                  onTap: () {
                    Get.to(() => const AddNewContactScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
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
                InkWell(
                  onTap: () {
                    Get.to(() => const ChatSettings());
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
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
              ]),
            ),
          )
        ],
      ),
    );
  }
}
