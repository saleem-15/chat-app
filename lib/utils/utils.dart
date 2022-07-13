import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(Timestamp time) {
    final myTimeFormat = DateFormat('h:mm a');

    return myTimeFormat.format((time).toDate());
  }
}
