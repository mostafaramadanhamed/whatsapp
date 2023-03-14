import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/massege_model.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/utils/constant/app_assets.dart';
final chatControllerProvider=Provider((ref){
  final  chatRepository=ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});
class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>>chatContact(){
    return chatRepository.getChatContact();
  }
  Stream<List<Message>>chatStream(String recieverUserId){
    return chatRepository.getChatStream(recieverUserId);
  }
  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
  try  {

      ref.read(userDataAuthProvider).whenData(
            (UserModel ? value) { log('$value value');
            return  chatRepository.sendTextMessage(
                context: context,
                text: text,
                receiverUserId: receiverUserId,
                senderUser: value??UserModel(name: 'null', uid: 'null', profilePic: AppAssets.oTBProfileImage, isOnline: false, phoneNumber: 'null', groupId: []) ,
              );
            }

      );

    }catch(e){print(e);}
  }

}