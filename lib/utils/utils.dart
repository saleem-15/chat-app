import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime time) {
    final myTimeFormat = DateFormat('h:mm a');

    return myTimeFormat.format(time);
  }

  static String getCollectionId(String docPath) {
    return docPath.split('/')[0];
  }

  static String getdocId(String docPath) {
    return docPath.split('/')[1];
  }

  static String getFileName(String url) {
    final name = FirebaseStorage.instance.refFromURL(url).name;
    // FirebaseStorage.instance.refFromURL(url).
    log('name from firebase is: $name');
    return name;
  }
}
