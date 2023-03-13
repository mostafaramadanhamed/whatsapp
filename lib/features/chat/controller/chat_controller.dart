import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/models/chat_contact.dart';
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
  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (dynamic value) => chatRepository.sendTextMessage(
        context: context,
        text: text, receiverUserId: receiverUserId,
        senderUser:value!,
      ),
    );
  }

}
