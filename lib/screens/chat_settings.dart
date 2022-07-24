// ignore_for_file: unnecessary_cast

import 'dart:developer';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';

import '../widgets/message_bubble.dart';
import '../helpers/message_bubble_settings.dart';
import 'package:flutter/material.dart';

class ChatSettings extends StatefulWidget {
  const ChatSettings({super.key});

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  double _currentSliderValue = MessageBubbleSettings.fontSize.value.toDouble();

  Rx<ChatBacground> chatBackgroundType = MessageBubbleSettings.backgroundType;
  Rx<Color> chatBackgroundColor = (MessageBubbleSettings.chatBackgroundColor as Rx<Color>);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat settings')),
      body: Obx(
        () => Column(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: chatBackgroundType.value == ChatBacground.image
                      ? Image.asset(
                          MessageBubbleSettings.chatBackgroundImage.value,
                          fit: BoxFit.fitWidth,
                        )
                      : Ink(
                          color: chatBackgroundColor.value,
                        ),
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(children: const [
                    SizedBox(
                      height: 40,
                    ),
                    MessageBubble(
                      textMessage: 'Hi ,how are you !',
                      username: 'friend',
                      userImage:
                          'https://firebasestorage.googleapis.com/v0/b/chat-app-2-d4f18.appspot.com/o/user_image%2F8bENyPZwSlS7zCaoVjF2PGwuR102.jpg?alt=media&token=8063ff56-44a3-4526-8469-2e8740627bbc',
                      timeSent: '9:12 AM',
                      isMyMessage: false,
                      isSequenceOfMessages: false,
                    ),
                    MessageBubble(
                      textMessage: 'I\'m fine !',
                      username: 'me',
                      userImage:
                          'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ontario.ca%2Fpage%2Fsmall-business-access&psig=AOvVaw2SiMNRfmayLpTO5uOFJcRK&ust=1654115095614000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCOjMvYvJivgCFQAAAAAdAAAAABAK',
                      timeSent: '9:12 AM',
                      isMyMessage: true,
                      isSequenceOfMessages: false,
                    )
                  ]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Text size'),
                      Slider(
                        value: _currentSliderValue,
                        max: 30,
                        min: 16,
                        divisions: 7,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            MessageBubbleSettings.setFontSize(value.toInt());
                            log('font size: $value');
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Background:'),
                      const Text('Color'),
                      Radio(
                        value: ChatBacground.color,
                        groupValue: chatBackgroundType.value,
                        onChanged: (value) async {
                          chatBackgroundType.value = value!;

                          if (chatBackgroundType.value == ChatBacground.color) {
                            await Get.defaultDialog(title: '', content: color());
                          }
                        },
                        activeColor: Colors.green,
                      ),
                      const Text('image'),
                      Radio(
                        value: ChatBacground.image,
                        groupValue: chatBackgroundType.value,
                        onChanged: (value) {
                          chatBackgroundType.value = value!;
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (chatBackgroundType.value == ChatBacground.image)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available backgrounds',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: backgroundImages(),
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget color() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        width: double.infinity,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
        child: ColorPicker(
          padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
          // starting color.
          color: chatBackgroundColor.value,
          onColorChanged: (Color color) {
            chatBackgroundColor.value = color;
          },
          copyPasteBehavior: const ColorPickerCopyPasteBehavior(
            longPressMenu: true,
          ),
          showColorCode: true,
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.both: false,
            ColorPickerType.primary: true,
            ColorPickerType.accent: false,
            ColorPickerType.bw: false,
            ColorPickerType.custom: true,
            ColorPickerType.wheel: true,
          },
          width: 44,
          height: 44,
          borderRadius: 22,
          heading: Text(
            'Select background color',
            style: Theme.of(context).textTheme.headline5,
          ),
          subheading: Text(
            'Select color shade',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget backgroundImages() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: MessageBubbleSettings.backgroundImages.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          MessageBubbleSettings.setchatBackgroundImage(MessageBubbleSettings.backgroundImages[index]);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 200,
          width: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              MessageBubbleSettings.backgroundImages[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
