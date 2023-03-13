import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat.dart';
import 'package:whatsapp/utils/constant/app_string.dart';
import 'package:whatsapp/utils/constant/firebase_constant.dart';

final selectContactRepositoryProvider=Provider((ref) =>
    SelectContactRepository(firestore: FirebaseFirestore.instance),
);
class SelectContactRepository{
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>>getContacts()async{
    List<Contact>contacts=[];
    try{
      if(await FlutterContacts.requestPermission()){
      contacts=await FlutterContacts.getContacts(withProperties: true,);
      }
    }
        catch(e){
      debugPrint(e.toString());
        }
        return contacts;
  }
  void selectContact(Contact selectedContact,BuildContext context)async{
    try{
      var userCollections=await firestore.collection(userCollection).get();
      bool isFound=false;
      for(var document in userCollections.docs){
        var userData=UserModel.fromMap(document.data());
        print(selectedContact.phones[0].number);
        String selectedPhoneNum=selectedContact.phones[0].number.replaceAll(' ', '',);
        if(selectedPhoneNum==userData.phoneNumber){
          isFound=true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,arguments: {
            'name':userData.name,
            'uid':userData.uid,
            'profilePic':userData.profilePic,
            'isOnline':userData.isOnline,
          });
        }else{}
      }   if(!isFound){
        showSnackBar(context: context, content: AppString.messageNumberNotFound);
      }
    }
        catch(ex){
      showSnackBar(context: context, content: ex.toString());
        }
  }
}