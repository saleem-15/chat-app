// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../api/firebase_api.dart';
import '../../../controllers/controller.dart';
import '../../../models/user.dart';
import '../components/user_info.dart';
import '../components/snack_bars.dart';
import '../service/add_new_contact.dart';
import '../service/find_user.dart';

class AddNewContactScreen extends StatefulWidget {
  const AddNewContactScreen({super.key});

  @override
  State<AddNewContactScreen> createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends State<AddNewContactScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  final _controller = TextEditingController();

  Rx<bool> userExists = false.obs;
  Rx<String> userEmail = ''.obs;
  Rx<String> userId = ''.obs;
  MyUser? foundUser;

  Rx<bool> scanQrCode = false.obs;
  bool isContactAddedBefore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add New chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: 'add the email of the new contact'),
                onChanged: (value) {
                  // if (value.isEmpty) {
                  //   setState(() {
                  //     searchDone = false;
                  //   });
                  // }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(200, 37))),
                onPressed: addNewContact,
                child: const Text('Add new contact'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(200, 37))),
                onPressed: () {
                  // Get.to(() => const QrReader());

                  // qrController?.pauseCamera();
                  scanQrCode.value = !scanQrCode.value;
                },
                child:
                    Obx(() => Text(scanQrCode.value ? 'Close scanner' : 'Scan Qr code')),
              ),
              Obx(
                () => Text(userEmail.isEmpty ? '' : 'User email: ${userEmail.value}'),
              ),
              Obx(
                () => scanQrCode.value
                    ? FutureBuilder(
                        future: Future.delayed(const Duration(milliseconds: 100)),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Container(
                            width: 400,
                            height: 400,
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: QRView(
                              formatsAllowed: const [BarcodeFormat.qrcode],
                              overlay: QrScannerOverlayShape(borderColor: Colors.white),
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => UserInfo(
                  foundUser: foundUser,
                  isUerExists: userExists.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addNewContact() async {
    //if the users clicked on 'addContact' more than once to the (same contact)

    final email = _controller.text.trim();

    if (email.isEmpty) {
      showSnackBar(SnackBars.textFieldIsEmpty);
      return;
    }

    if (!email.isEmail) {
      showSnackBar(SnackBars.notValidEmail);
      return;
    }

    foundUser = await FirebaseApi.findUserByEmail(email);
    setState(() {});

    if (foundUser == null) {
      // if the user was not found
      userExists.value = false;
      showSnackBar(SnackBars.userNotExist);
      return;
    }

    final userInMyContacts = findIsMyContactById(foundUser!.uid);
    log('is user exists: $userInMyContacts');
    if (userInMyContacts) {
      showSnackBar(SnackBars.userIsAlreadyInYourContacts);
      return;
    }

    // if the user was found
    await Get.find<Controller>().addNewContact(foundUser!);
    userExists.value = true;
    showSnackBar(SnackBars.userAddedSuccessfully);
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen(barcodeReader);
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  //this funcion makes hot reload works (related to the qr scanner)
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     qrController!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     qrController!.resumeCamera();
  //   }
  // }

  Future<void> barcodeReader(Barcode event) async {
    final data = event.code!;

    bool isValidQr = data.startsWith('Email:');

    if (!isValidQr) {
      return;
    }
    // barcode info ===> 'Email: (email)/(id)'
    final email = data.split(':')[1].split('/')[0];
    final id = data.split(':')[1].split('/')[1];

    userEmail.value = email;
    userId.value = id;

    scanQrCode.value = false; //close the qr reader

    Vibrate.feedback(FeedbackType.success);

    addNewContactViaBarcode(email, id);
  }
}
