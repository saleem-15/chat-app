import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageBubbleSettings {
  static int _fontSize = 0;

  static Future<int> getFontSize() async {
    if (_fontSize != 0) {
      return _fontSize; //if the value of fontsize is initializes
    }

    final prefs = await SharedPreferences.getInstance();

    _fontSize = prefs.getInt('message_font_size') ?? 16;

    return _fontSize;
  }

  static setFontSize(int newValue) async {
    _fontSize = newValue;
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('message_font_size', newValue);
  }

  static Color myMessageColor = Colors.green;
  static Color othersMessageColor = Colors.blue;
}
