// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/models/message.dart';

import '../models/message_type.dart';
import '../screens/picked_photo_viewer.dart';
import '../screens/picked_video_viewer.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    Key? key,
    required this.chatPath,
  }) : super(key: key);

  final String chatPath;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final recorder = FlutterSoundRecorder();

  final myID = Get.find<Controller>().myUser.uid;

  bool isRecordingReady = false;
  final _textController = TextEditingController();
  var text = ''.obs;

  void sendAudio(File audioFile) {
    final msg = Message.audio(chatPath: widget.chatPath, audio: audioFile.path, senderId: myID);
    Get.find<Controller>().sendAudio(msg);
  }

  void sendImage(File image, String? message) {
    final imageMessage = Message.image(chatPath: widget.chatPath, text: message, type: MessageType.photo, image: image.path, senderId: myID);
    Get.find<Controller>().sendPhoto(imageMessage);
  }

  void sendVideo(File video, String? message) {
    final videoMessage = Message.video(chatPath: widget.chatPath, text: message, type: MessageType.video, video: video.path, senderId: myID);
    Get.find<Controller>().sendVideo(videoMessage);
  }

  @override
  void initState() {
    super.initState();

    initRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final getController = Get.find<Controller>();
    return Obx(
      () => Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            //Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
          child: TextField(
            minLines: 1,
            maxLines: 5,
            controller: _textController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, top: 15),
              border: InputBorder.none,
              hintText: 'Message',
              fillColor: Colors.red,
              prefixIcon: IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: () {},
              ),
              suffixIcon: text.trim().isEmpty
                  ? SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          if (recorder.isRecording) recordingTime(),
                          if (!recorder.isRecording)
                            IconButton(
                              color: Theme.of(context).primaryColor,
                              icon: const FaIcon(FontAwesomeIcons.paperclip, size: 20),
                              onPressed: () async {
                                await Get.bottomSheet(chooseFileBottomSheet());

/*
                              final pickedVideo = await ImagePicker().pickVideo(
                                source: ImageSource.gallery,
                              );

                              if (pickedVideo == null) {
                                return;
                              }

                              final videoFile = File(pickedVideo.path);

                              Get.to(() => PickedVideoScreen(
                                    video: videoFile,
                                    sendVideo: sendVideo,
                                  ));
*/
                                // Get.bottomSheet(
                                //   MediaPicker(
                                //     mediaList: pickedMedia, //let MediaPicker know which medias are already selected by passing the previous mediaList
                                //     onPick: (selectedList) {
                                //       pickedMedia = selectedList;
                                //       print('Got Media ${selectedList.length}');
                                //     },
                                //     onCancel: () => print('Canceled'),
                                //     mediaCount: MediaCount.single,
                                //     mediaType: MediaType.image,
                                //     decoration: PickerDecoration(),
                                //   ),
                                // );

                                // Get.to(() => PickedPhotoViewer(
                                //       sendImage: sendImage,
                                //       image: imageFile,
                                //     ));
                              },
                            ),
                          IconButton(
                            color: Theme.of(context).primaryColor,
                            icon: Icon(recorder.isRecording ? Icons.stop : Icons.mic),
                            onPressed: () async {
                              if (recorder.isRecording) {
                                File audioFile = await stop();

                                Get.defaultDialog(
                                  title: 'Do you want to send the recording?',
                                  middleText: '',
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    ElevatedButton(
                                      child: const Text('Send'),
                                      onPressed: () {
                                        sendAudio(audioFile);
                                        Get.back();
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                await record();
                              }
                              setState(() {});
                            },
                          ),
                          if (!recorder.isRecording)
                            IconButton(
                              color: Theme.of(context).primaryColor,
                              icon: const Icon(Icons.camera_alt_rounded),
                              onPressed: () async {
                                final pickedImage = await ImagePicker().pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100,
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
                            ),
                        ],
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: () {
                        getController.sendMessage(_textController.text.trim(), widget.chatPath);
                        text.value = '';
                        _textController.clear();
                      },
                    ),
            ),
            onChanged: (value) => text.value = value,
          ),
        ),
      ]),
    );
  }

  Widget chooseFileBottomSheet() {
    final selectedIcon = 'image'.obs;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
      height: 100,
      padding: const EdgeInsets.only(left: 6, right: 6, top: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              selectedIcon.value = 'image';

              final pickedImage = await ImagePicker().pickImage(
                source: ImageSource.camera,
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
                  },
                ),
                cancel: TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
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

  recordingTime() {
    return StreamBuilder<RecordingDisposition>(
      stream: recorder.onProgress,
      builder: (context, snapshot) {
        final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;

        String twoDigits(int n) => n.toString().padLeft(1);
        final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return Text(
          '$twoDigitMinutes:$twoDigitSeconds',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecordingReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future record() async {
    if (!isRecordingReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<File> stop() async {
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    return audioFile;
  }
}
