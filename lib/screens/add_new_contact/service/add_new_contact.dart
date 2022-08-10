import 'package:get/get.dart';

import '../../../controllers/controller.dart';
import '../components/snack_bars.dart';
import 'find_user.dart';

void addNewContactViaBarcode(String userEmail, String id) async {
  //if the users clicked on 'addContact' more than once to the (same contact)

  final isAlreadyMyContact = findIsMyContactById(id);

  if (isAlreadyMyContact) {
    showSnackBar(SnackBars.userIsAlreadyInYourContacts);
    return;
  }

  //if the user is not in your contacts
  final user = await findUserById(id);

  await Get.find<Controller>().addNewContact(user!);

  showSnackBar(SnackBars.userAddedSuccessfully);
}
