import 'package:get/get.dart';

import '../helpers/message_bubble_settings.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.textMessage,
      required this.username,
      required this.userImage,
      required this.timeSent,
      required this.isMyMessage,
      required this.isSequenceOfMessages,
      this.messageColor,
      super.key});

  final String textMessage;
  final String username;
  final String userImage;
  final String timeSent;
  final bool isMyMessage;
  final bool isSequenceOfMessages;
  final Color? messageColor;

  @override
  Widget build(BuildContext context) {
    final messageMaxWidth = MediaQuery.of(context).size.width - 40;
    final List<bool> c = _calcLastLineEnd(context, messageMaxWidth, textMessage);
    final Rx<bool> isNeedPAdding = c[0].obs;
    final Rx<bool> isNeedNewLine = c[1].obs;

    var fontSize = MessageBubbleSettings.fontSize;
    return Row(
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            right: isMyMessage ? 8 : 0,
            left: isMyMessage ? 0 : 8,
            bottom: 5,
            top: 3,
          ),
          constraints: BoxConstraints(maxWidth: messageMaxWidth),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 199, 197, 197).withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: isMyMessage ? Radius.zero : const Radius.circular(20),
              topLeft: isMyMessage ? const Radius.circular(20) : Radius.zero,
              bottomRight: const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
            ),
            color: isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMyMessage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(
                        bottom: isNeedNewLine.value ? 20 : 0,
                        right: isNeedPAdding.value ? 60 : 0,
                      ),
                      child: Text(
                        textMessage,
                        style: TextStyle(
                          fontSize: fontSize.value.toDouble(),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: -3,
                right: 0,
                child: Text(
                  timeSent,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<bool> _calcLastLineEnd(BuildContext context, double maxWidth, String msg) {
    // self-defined constraint
    final constraints = BoxConstraints(
      maxWidth: maxWidth, // maxwidth calculated
      minHeight: 30.0,
      minWidth: 80.0,
    );
    final richTextWidget = Text.rich(TextSpan(text: msg)).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);
    final boxes = renderObject.getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: TextSpan(text: msg).toPlainText().length));
    bool needPadding = false, needNextline = false;
    if (boxes.length < 2 && boxes.last.right < 630) needPadding = true;
    if (boxes.length < 2 && boxes.last.right > 630) needNextline = true;
    if (boxes.length > 1 && boxes.last.right > 630) needNextline = true;
    return [needPadding, needNextline];
  }
}
