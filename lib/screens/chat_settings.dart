import 'dart:developer';

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
                  child: Image.asset(
                    MessageBubbleSettings.chatBackgroundImage.value,
                    fit: BoxFit.fitWidth,
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
                        onChanged: (value) {
                          chatBackgroundType.value = value!;
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
