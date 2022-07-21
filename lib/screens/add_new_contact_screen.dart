import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/firebase_api.dart';
import '../controllers/controller.dart';
import '../models/user.dart' ;

class AddNewContactScreen extends StatefulWidget {
  const AddNewContactScreen({super.key});

  @override
  State<AddNewContactScreen> createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends State<AddNewContactScreen> {
  final _contoroller = TextEditingController();

  bool userExists = false;
  bool searchDone = false;

  MyUser? foundUser;

  @override
  Widget build(BuildContext context) {
    // FirebaseApi.getChatId('0hJySe8l8JgUsiUMpeYZwEAzcup2').then((x) => log('chat_id----------->$x'));

    return Scaffold(
      appBar: AppBar(title: const Text('add New chat')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _contoroller,
                decoration: const InputDecoration(hintText: 'add the email of the new contact'),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      searchDone = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('Add new contact'),
                    onPressed: () async {
                      if (!userExists) {
                        return; // if the user was not found
                      }

                      Get.find<Controller>().addNewContact(foundUser!);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Find contact'),
                    onPressed: () async {
                      var user = await FirebaseApi.findUserByEmail(_contoroller.text.trim());

                      searchDone = true;
                      userExists = user == null ? false : true;

                      if (user != null) {
                        foundUser = MyUser(chatId: user.chatId, name: user.name, image: user.image, uid: user.uid);
                      }

                      setState(() {});
                    },
                  ),
                ],
              ),
              if (userExists) const Text('user exists'),
              const SizedBox(
                height: 30,
              ),
              if (userExists) Text('username: ${foundUser!.name}'),
              const SizedBox(
                height: 30,
              ),
              if (userExists)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(foundUser!.image),
                ),
              if (!userExists && searchDone) const Text('user does Not exists')
            ],
          ),
        ),
      ),
    );
  }
}
