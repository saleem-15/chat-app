import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../helpers/user_image_picker.dart';
import '../models/chat.dart';
import 'user_chats.dart';

class AddNewGroup2ndScreen extends StatelessWidget {
  AddNewGroup2ndScreen({required this.selectedPeople, super.key});

  final List<Chat> selectedPeople;

  final _groubNameController = TextEditingController();
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          final groupName = _groubNameController.text.trim();
          final List<String> selectedPeopleIds = [];

          for (var person in selectedPeople) {
            selectedPeopleIds.add(person.userId!);
          }

          if (groupName.isEmpty) {
            Fluttertoast.showToast(
                msg: "Enter the name of the group!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[500],
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          Get.find<Controller>().createGroupChat(groupName, selectedPeopleIds,_userImageFile);
          Get.to(() => const UserChats());
        },
      ),
      appBar: AppBar(
        title: const Text(
          'New Group',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // const CircleAvatar(
                //   radius: 25,
                //   backgroundColor: Colors.blue,
                //   child: Icon(
                //     Icons.camera_alt_outlined,
                //     color: Colors.white,
                //   ),
                // ),
                UserImagePicker(
                  icon: const Icon(Icons.camera_alt_outlined),
                  radius: 30,
                  isGroupImage: true,
                  isImagefromGallery: false,
                  imagePickFn: _pickedImage,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: _groubNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter group name',
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 4, thickness: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 15, left: 15),
              itemCount: selectedPeople.length,
              itemBuilder: (context, index) {
                final image = selectedPeople[index].image;
                final name = selectedPeople[index].name;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 3, bottom: 5),
                        child: Text(
                          '${selectedPeople.length} members',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(image),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(image),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
