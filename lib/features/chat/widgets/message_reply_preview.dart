import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_gif.dart';
import 'package:whatsapp/utils/constant/app_color.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({
    Key? key,
  }) : super(key: key);
  void cancelReply(WidgetRef ref){
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply=ref.watch(messageReplyProvider);


    final size=MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: size.width*0.84,
        decoration: BoxDecoration(
          color: mobileChatBoxColor.withOpacity(.8),
          borderRadius: BorderRadius.circular(12)
        ),
        margin:const EdgeInsets.only(left: 5,right: 13),
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(
                  messageReply!.isMe?'Me':'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),),
                GestureDetector(child: const Icon(Icons.close,size: 16,),onTap: ()=>cancelReply(ref),),
              ],
            ),
            const SizedBox(height: 8,),
            Container(
              constraints: BoxConstraints(maxHeight:size.height/4),
              width: size.width*0.84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black26,
              ),
              child: DisplayTextImageGIF(message: messageReply.message, type: messageReply.messageEnum,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
