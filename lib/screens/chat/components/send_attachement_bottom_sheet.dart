// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/picked_photo_viewer.dart';
import '../screens/picked_video_viewer.dart';

class SendFileBottomSheet extends StatelessWidget {
  const SendFileBottomSheet({
    Key? key,
    required this.sendImage,
    required this.sendVideo,
    required this.sendAudio,
  }) : super(key: key);

  final void Function(File image, String? message) sendImage;

  final void Function(File videoFile, String? message) sendVideo;

  final void Function(File audioFile) sendAudio;

  @override
  Widget build(BuildContext context) {
    final selectedIcon = 'image'.obs;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      height: 100,
      padding: const EdgeInsets.only(left: 6, right: 6, top: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              Get.back();

              selectedIcon.value = 'image';

              final pickedImage = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (pickedImage == null) {
                return;
              }

              final imageFile = File(pickedImage.path);

              Get.to(() => PickedPhotoViewer(
                    sendImage: sendImage,
                    image: imageFile,
                  ));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: FaIcon(
                    FontAwesomeIcons.solidImage,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  'Image',
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              Get.back();
              selectedIcon.value = 'video';

              final pickedVideo = await ImagePicker().pickVideo(
                source: ImageSource.gallery,
              );

              if (pickedVideo == null) {
                log('video path ${pickedVideo!.path}');
                return;
              }

              final videoFile = File(pickedVideo.path);

              Get.to(() => PickedVideoScreen(
                    video: videoFile,
                    sendVideo: sendVideo,
                  ));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: FaIcon(
                    FontAwesomeIcons.video,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Video',
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              selectedIcon.value = 'audio';

              final result = await FilePicker.platform.pickFiles(type: FileType.audio);

              if (result == null) {
                return;
              }

              File audioFile = File(result.paths[0]!);

              Get.defaultDialog(
                title: 'Do you want to send the audio?',
                titlePadding: const EdgeInsets.only(top: 10, right: 15, left: 15),
                middleText: '',
                confirm: ElevatedButton(
                  child: const Text('Send'),
                  onPressed: () {
                    sendAudio(audioFile);
                    Get.back();
                    Get.back();
                  },
                ),
                cancel: TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Text(
                  'Audio',
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              selectedIcon.value = 'file';

              final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);

              if (result != null) {
                // ignore: unused_local_variable
                List<File> files = result.paths.map((path) => File(path!)).toList();
              } else {
                // User canceled the picker
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.cyan[700],
                  child: const FaIcon(
                    FontAwesomeIcons.solidFile,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'File',
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
