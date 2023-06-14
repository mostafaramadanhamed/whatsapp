import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_gif.dart';
import '../../../utils/constant/app_color.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType, required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(userName);

    final isReplying=repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *.75,
            minWidth: MediaQuery.of(context).size.width * 0.35,
            minHeight: MediaQuery.of(context).size.width * 0.13,
          ),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            )),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 6,
                          bottom: 22,
                        )
                      : const EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 3,
                          bottom: 4,
                        ),
                  child: Column(

                    children:[if(isReplying) ...[
                     Column(
                       children: [
                         ConstrainedBox(

                           constraints: const BoxConstraints(minWidth: 90),
                           child: Container(
                               padding: const EdgeInsets.all(8),
                               decoration: BoxDecoration(
                                   color: backgroundColor.withOpacity(0.2),
                                 borderRadius:  const BorderRadius.only(
                                     topRight:Radius.circular(16),
                                     topLeft:Radius.circular(16),
                                     bottomLeft: Radius.circular(16),     )
                               ),
                               child: Column(
                                 children: [

                                   Text('$userName :',style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade300),),
                                   const SizedBox(height: 5,),
                                   DisplayTextImageGIF(message: repliedText, type: repliedMessageType),
                                 ],
                               )),
                         ),
                       ],
                     ),
                      const SizedBox(height: 5,),
                    ],
                      DisplayTextImageGIF(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: type == MessageEnum.text
                      ? Row(
                          children: [
                            Text(
                              date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                             Icon(
                                isSeen?Icons.done_all:Icons.done,
                              size: 18,
                              color: isSeen?Colors.blue:Colors.white60,
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.only(bottom: 7),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.4),
                              blurRadius: 28,
                              spreadRadius: 4,
                            )
                          ]),
                          child: Row(
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                isSeen?Icons.done_all:Icons.done,
                                size: 18,
                                color: isSeen?Colors.blue:Colors.white,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
