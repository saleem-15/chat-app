// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

import '../controllers/controller.dart';
import '../models/user.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({
    Key? key,
    required this.name,
    required this.image,
    required this.chatPath,
    required this.isGroup,
  }) : super(key: key);

  final String name;
  final String image;
  final String chatPath;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    final List<MyUser> users =
        isGroup ? Get.find<Controller>().getGroupUsers(chatPath) : [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: FlexibleHeaderDelegate(
              // builder: (context, progress) {
              //   log('progress: $progress');
              //   return const SizedBox.shrink();
              // },
              statusBarHeight: MediaQuery.of(context).padding.top,
              expandedHeight: 240,
              collapsedHeight: 40,
              background: MutableBackground(
                expandedWidget: Hero(
                  tag: image,
                  child: Image.file(
                    File(image),
                    fit: BoxFit.cover,
                  ),
                ),
                collapsedColor: Colors.blue,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              children: [
                FlexibleTextItem(
                  text: name,
                  collapsedStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  expandedStyle: const TextStyle(fontSize: 28, color: Colors.white),
                  expandedAlignment: Alignment.bottomLeft,
                  collapsedAlignment: Alignment.center,
                  expandedPadding: const EdgeInsets.only(left: 20, bottom: 20),
                ),
              ],
            ),
          ),
          if (isGroup)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 12,
                    height: 12,
                    color: Colors.grey[350],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: Text('${users.length} Members'),
                  ),
                ],
              ),
            ),
          if (isGroup)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: users.length,
                (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          log('tapped on ${users[index].name}');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(
                                chatPath: users[index].chatId!,
                                image: users[index].image,
                                name: users[index].name,
                                isGroup: false,
                              ),
                            ),
                          );

                          /// this code does not work here (I have no idea why !!)
                          // Get.to(
                          //   () => UserDetailsScreen(
                          //     chatPath: users[index].chatId!,
                          //     image: users[index].image,
                          //     name: users[index].name,
                          //     isGroup: false,
                          //   ),
                          // );
                        },
                        leading: Hero(
                          tag: users[index].image,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: FileImage(File(users[index].image)),
                          ),
                        ),
                        title: Text(
                          users[index].name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: GetBuilder<Controller>(
                          builder: (controller) => FutureBuilder(
                            future: controller.getLastTimeOnline(users[index].uid),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // if (lastSeen == null) {
                                return Text(
                                  'Connecting ...',
                                  style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 12,
                                  ),
                                );
                              }

                              return Text(
                                snapshot.data,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: snapshot.data == 'Online'
                                      ? Colors.blue
                                      : Colors.grey[500],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (users.length - 1 != index)
                        Padding(
                          padding: const EdgeInsets.only(left: 80),
                          child: Divider(
                            height: 0,
                            color: Colors.grey[400],
                          ),
                        )
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
