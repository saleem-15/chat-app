// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

// import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
// import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
import 'package:chat_app/widgets/send_attachement_bottom_sheet.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/controller.dart';
import '../models/message.dart';
import '../models/message_type.dart';
import '../screens/picked_photo_viewer.dart';

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
  late final FlutterSoundRecorder recorder;
  late final String myID;
  late final TextEditingController _textController;

  bool isRecordingReady = false;
  String text = '';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    inputNode = FocusNode();
    myID = Get.find<Controller>().myUser.uid;
    recorder = FlutterSoundRecorder();
    // _textController.addListener(() {
    //   log('text has changed');
    //   //remove the notmal keyboard if it was opened
    //   FocusScopeNode currentFocus = FocusScope.of(context);
    //   if (_textController.text.isNotEmpty) {
    //     currentFocus.requestFocus(inputNode);
    //     // currentFocus.unfocus();
    //   }
    //   _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
    // });
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    _textController.dispose();
    inputNode.dispose();

    super.dispose();
  }

  late final FocusNode inputNode;

  bool showEmojiKeyboard = false;
  @override
  Widget build(BuildContext context) {
    final getController = Get.find<Controller>();
    return Stack(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
                  child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      focusNode: inputNode,
                      controller: _textController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20, top: 15),
                        border: InputBorder.none,
                        hintText: 'Message',
                        fillColor: Colors.red,
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
                                        onPressed: showBottomSheet,
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
                                  if (mounted) {
                                    setState(() {
                                      log('set State()');
                                      text = '';
                                    });
                                  }

                                  _textController.clear();
                                },
                              ),
                      ),
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            log('set State()');
                            text = value;
                          });
                        }
                      }),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4),
                    child: IconButton(
                      icon: showEmojiKeyboard //
                          ? const Icon(Icons.keyboard) //
                          : const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {
                        if (showEmojiKeyboard) {
                          log('show emoji keyboard: $showEmojiKeyboard');
                          log('keyboard button is pressed');
                          //if the emoji keyboard is shown
                          if (mounted) {
                            setState(() {
                              log('set State()');
                              showEmojiKeyboard = false;
                            });
                          }
                          openNormalKeyboard();
                        } else {
                          log('emoji button is pressed');
                        }

                        //remove the notmal keyboard if it was opened
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        if (mounted) {
                          setState(() {
                            log('set State()');
                            showEmojiKeyboard = !showEmojiKeyboard;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: showEmojiKeyboard,
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    if (mounted) {
                      setState(() {
                        log('set State()');
                        text += emoji.emoji;
                      });
                    }
                    _textController.text += emoji.emoji;
                  },
                  onBackspacePressed: () {
                    // Backspace-Button tapped logic
                    // Remove this line to also remove the button in the UI
                    final textFiledText = _textController.text;

                    bool isEmo = isEmoji(text.substring(textFiledText.length - 2, textFiledText.length));
                    if (isEmo) {
                      _textController.text = text.substring(0, textFiledText.length - 2);

                      if (mounted) {
                        setState(() {
                          log('set State()');
                          text = text.substring(0, textFiledText.length - 2);
                        });
                      }
                    } else {
                      final length = textFiledText.length;
                      _textController.text = text.substring(0, textFiledText.length - 1);

                      if (mounted) {
                        setState(() {
                          log('set State()');
                          text = text.substring(0, textFiledText.length - 1);
                        });
                      }
                      if (length == 2) _textController.clear();
                    }
                  },
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    progressIndicatorColor: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void openNormalKeyboard() {
    //FocusScope.of(context).requestFocus(inputNode); //open normal keyboard
    if (mounted) {
      setState(() {
        log('set State()');
        showEmojiKeyboard = false; //close emoji keyboard
      });
    }
  }

  void openEmojiKeyboard() {
    if (mounted) {
      setState(() {
        log('set State()');
        showEmojiKeyboard = true; //open emoji keyboard
      });
    }
    FocusScope.of(context).requestFocus(inputNode); //open normal keyboard
  }

  void showBottomSheet() async {
    await Get.bottomSheet(SendFileBottomSheet(
      sendImage: sendImage,
      sendVideo: sendVideo,
      sendAudio: sendAudio,
    ));
  }

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

  Future record() async {
    if (!isRecordingReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<File> stop() async {
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    return audioFile;
  }

  bool isEmoji(String text) {
    final RegExp emojiRegex = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    return emojiRegex.hasMatch(text);
  }
}
