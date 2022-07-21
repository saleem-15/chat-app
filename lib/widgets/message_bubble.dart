import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 199, 197, 197).withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
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
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      right: 55,
                    ),
                    child: Obx(
                      () => Text(
                        textMessage,
                        style: TextStyle(fontSize: fontSize.value.toDouble()),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
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

    // Stack(
    //   clipBehavior: Clip.none,
    //   children: [
    //     if (!isMyMessage && !isSequenceOfMessages) // if the message is not mine  AND this is the first messagge in the sequence
    //       Positioned(
    //         top: -15,
    //         left: 5,
    //         child: CircleAvatar(
    //           radius: 22,
    //           backgroundImage: NetworkImage(userImage, scale: .5),
    //         ),
    //       ),
    //     Row(
    //       mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
    //       children: [
    //         const SizedBox(
    //           width: 20,
    //         ),
    //         ConstrainedBox(
    //           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
    //           child: Container(
    //             // the message
    //             margin: const EdgeInsets.symmetric(
    //               vertical: 5,
    //               horizontal: 7,
    //             ),
    //             padding: const EdgeInsets.all(10),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(
    //                 topRight: isMyMessage ? Radius.zero : const Radius.circular(20),
    //                 topLeft: isMyMessage ? const Radius.circular(20) : Radius.zero,
    //                 bottomRight: const Radius.circular(20),
    //                 bottomLeft: const Radius.circular(20),
    //               ),
    //               color: messageColor ?? (isMyMessage ? MessageBubbleSettings.myMessageColor : MessageBubbleSettings.othersMessageColor),
    //             ),
    //             child: Column(
    //               crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    //               children: [
    //                 if (!isMyMessage)
    //                   Text(
    //                     // UserName
    //                     username,
    //                     style: const TextStyle(fontWeight: FontWeight.bold),
    //                   ),
    //                 FittedBox(
    //                   fit: BoxFit.contain,
    //                   child: Row(
    //                     children: [
    //                       Text(
    //                         //message Text
    //                         textMessage,
    //                         style: TextStyle(fontSize: fontSize),
    //                       ),
    //                       Align(
    //                         alignment: Alignment.bottomRight,
    //                         child: Padding(
    //                           //Time Sent
    //                           padding: const EdgeInsets.only(left: 15, top: 10),
    //                           child: Text(
    //                             timeSent,
    //                             style: const TextStyle(fontSize: 12),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  // Widget bubble() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Row(
  //           children: const [
  //             Text('saleem mahdi'),
  //           ],
  //           Container()
  //         )
  //       ],
  //     ),
  //   );
  // }
}












///--------------------------------------------------------------------------------
// import 'package:flutter/material.dart';

// class MessageBubble extends StatelessWidget {
//   const MessageBubble({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
//       color: Colors.blue,
//       child: Column(
//         children: [
//           Row(
//             children: const [
//               Text('saleem'),
//             ],
//           ),
//           const Text('hello this is a message that containes some text '),
//         ],
//       ),
//     );
//   }
// }
