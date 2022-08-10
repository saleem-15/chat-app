// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../helpers/utils.dart';

class FileManager {
  static final _instance = FileManager();
  static FileManager get instance => _instance;

  static Future<void> initFiles() async {
    //this function creates the file structure for the app
    final appDir = await getExternalStorageDirectory();
    await Directory('${appDir!.path}/chats').create();
    await Directory('${appDir.path}/Group_chats').create();

    return;
  }

  Future<String> storagePath(String chatPath) async {
    await initFiles(); //makes sure that the file structure is valid
    final appDir = await getExternalStorageDirectory();
    final path = '${appDir!.path}/$chatPath';
    await Directory(path).create();
    return path;
  }

  Future<void> saveToFile(File file, String chatPath) async {
    // log('the file to be saved: ${file.path}');
    final path = await storagePath(chatPath); //the folder path

    final fileName = basename(file.path);

    file.copy('$path/$fileName');
    log('FileManage => saveToFile => the file is saved in  =>$path/$fileName');
  }

  Future<File> getFile(String fileName, String chatPath) async {
    final path = await storagePath(chatPath);

    return File('$path/$fileName');
  }

  Future<bool> isFileSaved(String fileUrl, String chatPath) async {
    final fileName = Utils.getFileName(fileUrl);

    final path = await storagePath(chatPath);
    final dir = Directory(path);
    await dir.create();
    final filesList = dir.listSync();

    final isSaved = filesList.any((file) {
      final fname = basename(file.path);

      if (fileName == fname) {
        return true;
      }
      return false;
    });

    if (isSaved) {
      log('$fileName is SAVED before');
      return true;
    } else {
      log('$fileName is NOT saved before');
      return false;
    }
  }

  Future<String> findExistingFileStoragePath(String fileURl, String chatPath) async {
    final appDir = await getExternalStorageDirectory();
    final fileName = Utils.getFileName(fileURl);

    final path = '${appDir!.path}/$chatPath/$fileName';
    return path;
  }

  Future<String> saveFileFromNetwork(String fileURl, String chatPath) async {
    /// returns the path of the saved image
    /// Warning: this function works only on 'Firebase Storage'
    final isSaved = await isFileSaved(fileURl, chatPath);

    if (isSaved) {
      // throw Exception('saveFileFromNetwork = >the file is saved before ');

      return await findExistingFileStoragePath(fileURl, chatPath);
    }

    final fileName = Utils.getFileName(fileURl);
    final response = await http.get(Uri.parse(fileURl));

    final path = await storagePath(chatPath);

    final imageFile = File('$path/$fileName');

    await imageFile.writeAsBytes(response.bodyBytes);

    return imageFile.path;
  }

  Future<void> deleteFile(String imageUrl, String chatPath) async {
    final fileName = Utils.getFileName(imageUrl);
    final path = await storagePath(chatPath);

    final image = File('$path/$fileName');

    await image.delete();
  }
}
