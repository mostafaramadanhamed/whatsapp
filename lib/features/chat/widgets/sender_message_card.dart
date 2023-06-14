import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import '../../../utils/constant/app_color.dart';
import 'display_text_image_gif.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type, required this.onRightSwipe, required this.repliedText, required this.userName, required this.repliedMessageType,

  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  @override
  Widget build(BuildContext context) {
    final isReplying=repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *.75,
            minWidth: MediaQuery.of(context).size.width*0.33,
            minHeight: MediaQuery.of(context).size.width * 0.13,

          ),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(borderRadius:  BorderRadius.only(
              topRight:Radius.circular(16),
              topLeft:Radius.circular(16),
              bottomRight: Radius.circular(16),
            )),          color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type==MessageEnum.text?  const EdgeInsets.only(
                    left: 7,
                    right: 5,
                    top: 6,
                    bottom: 10,
                  ): const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 3,
                    bottom: 4,
                  ),
                  child:Column(

                    children:[if(isReplying) ...[

                      ConstrainedBox(

                        constraints: const BoxConstraints(minWidth: 90,),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: blackColor.withOpacity(0.4),
                                borderRadius: const BorderRadius.only(
                                  topRight:Radius.circular(16),
                                  topLeft:Radius.circular(16),
                                  bottomRight: Radius.circular(16),     )
                            ),
                            child:  Column(
                              children: [

                                Text('$userName :',style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade300),),
                                const SizedBox(height: 5,),
                                DisplayTextImageGIF(message: repliedText, type: repliedMessageType),
                              ],
                            )),
                      ),
                      const SizedBox(height: 5,),
                    ],
                      DisplayTextImageGIF(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 1.6,
                  right: 10,
                   child:type==MessageEnum.text?Text(
                   date,
                   style: const TextStyle(
                     fontSize: 11,
                     color: Colors.white60,
                   ),
                ):
                   Container(
          padding:const EdgeInsets.only(bottom: 7),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.4),blurRadius:28,spreadRadius: 4, )
              ]
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
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