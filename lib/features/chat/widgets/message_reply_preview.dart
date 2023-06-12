import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';

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
    return Container(
      width: size.width-40,
      padding:const EdgeInsets.all(8.0),
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
              GestureDetector(child: Icon(Icons.close,size: 16,),onTap: (){    },),
            ],
          ),
          const SizedBox(height: 8,),
          Text(
            messageReply.message,
          ),
        ],
      ),
    );
  }
}
