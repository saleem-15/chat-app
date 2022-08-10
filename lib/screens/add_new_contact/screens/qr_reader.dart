import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../service/add_new_contact.dart';

class QrReader extends StatefulWidget {
  const QrReader({super.key});

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  String userEmail = '';
  String userId = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  @override
  Widget build(BuildContext context) {
    return QRView(
      formatsAllowed: const [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(borderColor: Colors.white),
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
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

  Future<void> barcodeReader(Barcode event) async {
    final data = event.code!;

    bool isValidQr = data.startsWith('Email:');

    if (!isValidQr) {
      return;
    }
    // barcode info ===> 'Email: (email)/(id)'
    final email = data.split(':')[1].split('/')[0];
    final id = data.split(':')[1].split('/')[1];

    userEmail = email;
    userId = id;

    Vibrate.feedback(FeedbackType.success);

    addNewContactViaBarcode(email, id);
    Get.back(result: {'email': email, 'id': id}); //close the qr reader
  }
}
