import 'dart:developer';
import 'dart:io';

import 'package:chat_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class FileManager {
  static final _instance = FileManager();
  static FileManager get instance => _instance;

  static Future<void> initFiles() async {
    //this function creates the file structure for the app
    final appDir = await getExternalStorageDirectory();
    await Directory('${appDir!.path}/chats').create();
    return;
  }

  Future<String> storagePath(String chatPath) async {
    await initFiles(); //makes sure that the file structure is valid
    final appDir = await getExternalStorageDirectory();
    final path = '${appDir!.path}/$chatPath';
    await Directory(path).create();
    return path;
  }

  Future<void> saveImageToFile(File image, String chatPath) async {
    log(image.path);
    final path = await storagePath(chatPath);

    final fileName = basename(image.path);

    image.copy('$path/$fileName');
  }

  Future<File> getImage(String imageName, String chatPath) async {
    final path = await storagePath(chatPath);

    return File('$path/$imageName');
  }

  Future<bool> isImageSaved(String imageUrl, String chatPath) async {
    final imageName = Utils.getImageName(imageUrl);

    final path = await storagePath(chatPath);
    final dir = Directory(path);
    await dir.create();
    final filesList = dir.listSync();

    final isSaved = filesList.any((file) {
      final fileName = basename(file.path);

      if (fileName == imageName) {
        return true;
      }
      return false;
    });

    if (isSaved) {
      log('$imageName is SAVED before');
      return true;
    } else {
      log('$imageName is NOT saved before');
      return false;
    }
  }

  Future<String> saveImageFromNetwork(String imageUrl, String chatPath) async {
    /// returns the path of the saved image
    /// Warning: this function works only on 'Firebase Storage'
    final isSaved = await isImageSaved(imageUrl, chatPath);

    if (isSaved) {
      return '';
    }

    final imageName = Utils.getImageName(imageUrl);
    final response = await http.get(Uri.parse(imageUrl));

    final path = await storagePath(chatPath);

    final imageFile = File('$path/$imageName');

    await imageFile.writeAsBytes(response.bodyBytes);

    return imageFile.path;
  }

  Future<void> deleteImage(String imageUrl, String chatPath) async {
    final imageName = Utils.getImageName(imageUrl);
    final path = await storagePath(chatPath);

    final image = File('$path/$imageName');

    await image.delete();
  }
}
