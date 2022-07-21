import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(Timestamp time) {
    final myTimeFormat = DateFormat('h:mm a');

    return myTimeFormat.format((time).toDate());
  }

  static String getCollectionId(String docPath) {
    return docPath.split('/')[0];
  }

  static String getdocId(String docPath) {
    return docPath.split('/')[1];
  }

  static String getImageName(String url) {
   return FirebaseStorage.instance.refFromURL(url).name;
  }
}
