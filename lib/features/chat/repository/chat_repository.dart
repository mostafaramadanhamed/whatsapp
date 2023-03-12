import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/utils/constant/firebase_constant.dart';

class ChatRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
});

  void _saveDataToContactsSubCollection(
      UserModel senderUserData,
      UserModel receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId,
      )async{
    var receiverChatContact=ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
    );
    await firestore
        .collection(FirebaseConstant.userCollection)
        .doc(receiverUserId)
        .collection(FirebaseConstant.chatCollection)
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());
    var senderChatContact=ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection(FirebaseConstant.userCollection)
        .doc(auth.currentUser!.uid)
        .collection(FirebaseConstant.chatCollection)
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }
void  _saveMessageToMessageSubCollection(
  {
   required String text,
   required DateTime timeSent,
   required String receiverUserId,
   required String messageId,
   required String userName,
   required String receiverUserName,
    required MessageEnum messageType,
})async{
    
  }

  void sendTextMessage({
  required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser
}) async {

    try{
      var timeSent=DateTime.now();
      UserModel receiverUserData;
        var userDataMap=await firestore.
      collection(FirebaseConstant.userCollection)
          .doc(receiverUserId).
      get();
        receiverUserData=UserModel.fromMap(userDataMap.data()!);
        _saveDataToContactsSubCollection(
            senderUser,
            receiverUserData,
            text,
          timeSent,
            receiverUserId,
        );

    }
        catch(ex){
      showSnackBar(context: context, content: ex.toString());
        }
}
}