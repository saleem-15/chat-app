// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/controllers/controller.dart';
import 'package:chat_app/models/message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/picked_photo_viewer.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({required this.chatPath, super.key});
  final String chatPath;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final recorder = FlutterSoundRecorder();

  bool isRecordingReady = false;
  final _textController = TextEditingController();
  var text = ''.obs;

  void sendAudio(File audioFile) {
    final msg = Message.audio(chatPath: widget.chatPath, audio: audioFile);
    Get.find<Controller>().sendAudio(msg);
  }

  void sendImage(File image, String? message) {
    final imageMessage = Message.image(chatPath: widget.chatPath, text: message, type: MessageType.photo, image: image);
    Get.find<Controller>().sendPhoto(imageMessage);
  }

  void sendVideo(File video, String? message) {
    final videoMessage = Message.video(chatPath: widget.chatPath, text: message, type: MessageType.photo, video: video);
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
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(allowMultiple: true);

                                if (result != null) {
                                  List<File> files = result.paths.map((path) => File(path!)).toList();
                                } else {
                                  // User canceled the picker
                                }

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
                                  textCancel: 'cancel recording',
                                  textConfirm: 'send recording',
                                  onConfirm: () {
                                    sendAudio(audioFile);
                                    Get.back();
                                  },
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
