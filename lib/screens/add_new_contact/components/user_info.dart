import 'package:flutter/material.dart';

import '../../../models/user.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.foundUser,
    required this.isUerExists,
  }) : super(key: key);

  final bool isUerExists;

  final MyUser? foundUser;

  @override
  Widget build(BuildContext context) {
    return isUerExists
        ? Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text('username: ${foundUser!.name}'),
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(foundUser!.image),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
