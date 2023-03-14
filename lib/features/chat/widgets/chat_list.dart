import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/models/massege_model.dart';
import 'package:whatsapp/widgets/sender_message_card.dart';
import '../../../widgets/my_message_card.dart';


class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList( {required this.recieverUserId,Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController=ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.watch(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Loader();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData=snapshot.data![index];
            var timeSent=DateFormat.Hm().format(messageData.timeSent);
            if (messageData.senderId==FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
            );
          },
        );
      }
    );
  }
}