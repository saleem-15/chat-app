import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackBars {
  userNotExist,
  userIsAlreadyInYourContacts,
  userAddedSuccessfully,
  textFieldIsEmpty,
  notValidEmail,
}

const userAddedSuccesfully = GetSnackBar(
  margin: EdgeInsets.all(15),
  message: 'User was added sucessfully',
  backgroundColor: Color(0xFF29D49F),
  duration: Duration(seconds: 5),
  borderRadius: 10,
);

const userIsAlreadyInYourContacts = GetSnackBar(
  margin: EdgeInsets.all(15),
  message: 'User is already in your contacts',
  backgroundColor: Color(0xFFFC6969),
  duration: Duration(seconds: 5),
  borderRadius: 10,
);

const notValidEmail = GetSnackBar(
  margin: EdgeInsets.all(15),
  message: 'Enter a valid email',
  backgroundColor: Color(0xFFFC6969),
  duration: Duration(seconds: 5),
  borderRadius: 10,
);

const textFieldIsEmpty = GetSnackBar(
  margin: EdgeInsets.all(15),

  message: 'Enter the email first!',
  // backgroundColor: Color(0xFF29D49F),
  duration: Duration(seconds: 3),
  borderRadius: 10,
);

const userNotExist = GetSnackBar(
  margin: EdgeInsets.all(15),
  duration: Duration(seconds: 5),
  borderRadius: 10,
  backgroundColor: Colors.redAccent,
  message: 'There is no user with this email',
);

void showSnackBar(SnackBars type) {
  switch (type) {
    case SnackBars.userAddedSuccessfully:
      Get.showSnackbar(userAddedSuccesfully);
      break;

    case SnackBars.userNotExist:
      Get.showSnackbar(userNotExist);
      break;

    case SnackBars.userIsAlreadyInYourContacts:
      Get.showSnackbar(userIsAlreadyInYourContacts);
      break;

    case SnackBars.textFieldIsEmpty:
      Get.showSnackbar(textFieldIsEmpty);
      break;

    case SnackBars.notValidEmail:
      Get.showSnackbar(notValidEmail);
      break;

    default:
  }
}
