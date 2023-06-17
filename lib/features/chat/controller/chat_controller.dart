import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/massege_model.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/utils/constant/app_assets.dart';

import '../../../common/providers/message_reply_provider.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContact() {
    return chatRepository.getChatContact();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
      BuildContext context,
      String text,
      String receiverUserId,
      ) {      final messageReply=ref.read(messageReplyProvider);

  try {
    ref.read(userDataAuthProvider).whenData((UserModel? value) {
      log('$value value');
      return chatRepository.sendTextMessage(
        context: context,
        text: text,
        receiverUserId: receiverUserId,
        senderUser: value ??
            // todo remove value
            UserModel(
                name: 'null',
                uid: 'null',
                profilePic: AppAssets.oTBProfileImage,
                isOnline: false,
                phoneNumber: 'null',
                groupId: []),
        messageReply:messageReply,
      );
    });
    ref.read(messageReplyProvider.notifier).update((state) => null);
  } catch (e) {
    print(e);
  }
  }
  void sendGIFMessage(
      BuildContext context,
      String gifUrl,
      String receiverUserId,
      ) {
    final messageReply=ref.read(messageReplyProvider);

    int gifUrlPartIndex=gifUrl.lastIndexOf('-')+1;
    String gifUrlPart=gifUrl.substring(gifUrlPartIndex);
    String newGifUrl='https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((UserModel? value) {
      log('$value value');
      return chatRepository.sendGIFMessage(context: context, gifUrl: newGifUrl,
        messageReply: messageReply,
        receiverUserId: receiverUserId,
        senderUser: value ??
            UserModel(
                name: 'null',
                uid: 'null',
                profilePic: AppAssets.oTBProfileImage,
                isOnline: false,
                phoneNumber: 'null',
                groupId: []),);
    });
    ref.read(messageReplyProvider.notifier).update((state) => null);


  }

  void sendFileMessage(
      BuildContext context,
      File file,
      String receiverUserId,
      MessageEnum messageEnum,
      ) {
    final messageReply=ref.read(messageReplyProvider);

    try {

      ref.read(userDataAuthProvider).whenData((UserModel? value) {
        log('$value value');
        return chatRepository.sendFileMessage(
          context: context,
          file: file,
          receiverUserId: receiverUserId,
          messageReply: messageReply,
          senderUserData: value ??
              UserModel(
                  name: 'Me',
                  uid: 'uIIId',
                  profilePic: AppAssets.oTBProfileImage,
                  isOnline: false,
                  phoneNumber: '0000',
                  groupId: []),
          ref: ref,
          messageEnum: messageEnum,
        );
      });
      ref.read(messageReplyProvider.notifier).update((state) => null);

    } catch (e) {
      print(e);
    }
  }
  void setMessageSeen( BuildContext context,
      String receiverUserId,
      String messageId,
      ){
    chatRepository.setMessageSeen(context, receiverUserId, messageId);
  }
}