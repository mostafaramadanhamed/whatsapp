import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/models/user_model.dart';
import '../widgets/bottom_chat_field.dart';
import '../../../utils/constant/app_color.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName='/mobile-chat';
  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);
final String name,uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Loader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                ),
                Text(snapshot.data!.isOnline?'online':'offline',style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                )),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children:  [
             Expanded(
            child: ChatList(recieverUserId: uid,),
          ),
          BottomChatField(receiverUserId: uid,),
        ],
      ),
    );
  }
}
