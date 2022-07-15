// ignore_for_file: must_be_immutable

import 'package:chat_app/screens/add_new_group_second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../models/chat.dart';

class AddNewGroupScreen extends StatelessWidget {
  AddNewGroupScreen({super.key});

  //this list containes the indices of the selected people
  // for example if (selectedPeople = [2,3]) ==> then ==> contacts[2] ,contacts[3] are selected

  final selectedPeople = <int>[].obs;
  var contacts = <Rx<Chat>>[];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            final selected = <Chat>[];
            for (var i = 0; i < selectedPeople.length; i++) {
              selected.add(contacts[selectedPeople[i]].value);
            }

            Get.to(() => AddNewGroup2ndScreen(selectedPeople: selected));
          },
        ),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Group',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                selectedPeople.isNotEmpty ? '${selectedPeople.length} selected' : 'unlimited number of members',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        body: GetBuilder<Controller>(
          builder: (controller) {
            contacts = controller.myChatsList.where((e) => e.value.isGroupChat == false).toList();

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: selectedPeople.isEmpty ? 50 : 130,
                  ),
                  child: selectedPeople.isEmpty
                      ? const Center(child: Text('No one is selected'))
                      : AlignedGridView.extent(
                          crossAxisSpacing: 5,

                          maxCrossAxisExtent: 100,
                          shrinkWrap: true,
                          itemCount: selectedPeople.length,
                          //    mainAxisSpacing: 20,
                          //  crossAxisSpacing: 4,
                          itemBuilder: (context, index) {
                            final selectedPerson = contacts[selectedPeople[index]].value;
                            return Chip(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: Colors.grey.shade300,
                              avatar: CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(selectedPerson.image),
                                backgroundColor: Colors.grey.shade200,
                              ),
                              label: Text(selectedPerson.name),
                            );
                          },
                        ),
                ),
                const Divider(
                  height: 0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final image = contacts[index].value.image;
                      final name = contacts[index].value.name;

                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              if (!selectedPeople.contains(index)) {
                                selectedPeople.add(index);
                              } else {
                                selectedPeople.remove(index);
                              }
                            },
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(image),
                                ),
                                if (selectedPeople.contains(index))
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(1),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.green,
                                        child: Icon(
                                          Icons.done,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
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
            );
          },
        ),
      ),
    );
  }
}
