import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/common/repository/firebasre_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/massege_model.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/utils/constant/app_string.dart';
import 'package:whatsapp/utils/constant/firebase_constant.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(chatCollection)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var documents in event.docs) {
        var chatContact = ChatContact.fromMap(documents.data());
        var userData = await firestore
            .collection(userCollection)
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(chatCollection)
        .doc(recieverUserId)
        .collection(messageCollection)
        .orderBy(orderBy)
        .snapshots()
        .asyncMap((event) async {
      List<Message> message = [];
      for (var documents in event.docs) {
        message.add(
          Message.fromMap(documents.data()),
        );
      }
      return message;
    });
  }

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection(userCollection)
        .doc(receiverUserId)
        .collection(chatCollection)
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());
    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(chatCollection)
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
    print(userCollection);
    print(messageCollection);
    print(chatCollection);
  }

  void _saveMessageToMessageSubCollection({
    required String text,
    required DateTime timeSent,
    required String receiverUserId,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
    required MessageReply ? messageReply,
    required MessageEnum repliedMessageType,
 //   required String receiverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      recieverid: receiverUserId,
      repliedMessageType:repliedMessageType,
      repliedTo: messageReply == null? '':messageReply.isMe?userName:receiverUserName,
      repliedMessage: messageReply == null ?'':messageReply.message,

    );
    await firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(chatCollection)
        .doc(receiverUserId)
        .collection(messageCollection)
        .doc(messageId)
        .set(message.toMap());
    await firestore
        .collection(userCollection)
        .doc(receiverUserId)
        .collection(chatCollection)
        .doc(auth.currentUser!.uid)
        .collection(messageCollection)
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection(userCollection).doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );
      _saveMessageToMessageSubCollection(
        text: text,
        timeSent: timeSent,
        receiverUserId: receiverUserId,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.text, repliedMessageType: messageReply==null?MessageEnum.text:messageReply.messageEnum, messageReply: messageReply,
      );
    } catch (ex) {
      showSnackBar(context: context, content: ex.toString());
    }
  }
  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply ? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection(userCollection).doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        'GIF',
        timeSent,
        receiverUserId,
      );
      _saveMessageToMessageSubCollection(
        text: gifUrl,
        timeSent: timeSent,
        receiverUserId: receiverUserId,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.gif, messageReply: messageReply, repliedMessageType: messageReply==null?MessageEnum.gif:messageReply.messageEnum,
      );
    } catch (ex) {
      showSnackBar(context: context, content: ex.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply ? messageReply,

  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl=await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
            file,
          );
      UserModel receiverUserData;
      var userDatMap =
          await firestore.collection(userCollection).doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDatMap.data()!);
      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📽 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎙 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = ' GIF';
          break;
        default:
          contactMsg = 'Gif';
      }
      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        contactMsg,
        timeSent,
        receiverUserId,
      );
      _saveMessageToMessageSubCollection(
        text: imageUrl,
        timeSent: timeSent,
        receiverUserId: receiverUserId,
        messageId: messageId,
        userName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: messageEnum, messageReply: messageReply, repliedMessageType: messageReply==null?MessageEnum.image:messageReply.messageEnum ,
      );
    } catch (ex) {
      showSnackBar(context: context, content: ex.toString());
    }
  }
  void setMessageSeen(
      BuildContext context,
      String receiverUserId,
      String messageId,
      )async{
    try{
      await firestore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .collection(chatCollection)
          .doc(receiverUserId)
          .collection(messageCollection)
          .doc(messageId)
          .update(
          {
            'isSeen': true,
          },
      );
      await firestore
          .collection(userCollection)
          .doc(receiverUserId)
          .collection(chatCollection)
          .doc(auth.currentUser!.uid)
          .collection(messageCollection)
          .doc(messageId)
          .update(
          {
            'isSeen': true,
          },
      );
    }
        catch(ex){
      showSnackBar(context: context, content: ex.toString());
        }
  }

}
