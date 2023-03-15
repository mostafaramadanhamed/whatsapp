import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/repository/firebasre_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/screens/otb_screen.dart';
import 'package:whatsapp/features/auth/screens/user_info.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/screens/mobile_layout.dart';
import 'package:whatsapp/utils/constant/app_assets.dart';
import 'package:whatsapp/utils/constant/firebase_constant.dart';

final authRepositoryProvider = Provider((ref) =>
    AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
) ,
);
class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel ? >getCurrentUserData()async{
    var userData= await firestore.
    collection(userCollection)
        .doc(auth.currentUser?.uid).
    get();
    UserModel ? user;
    if(userData.data() != null){
      user=UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(String phoneNumber,BuildContext context)async{
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          },
          verificationFailed: (e){
          throw Exception(e.message);
          },
          codeSent: (String verificationId , int ? resendToken)async{
          Navigator.pushNamed(context, OtbScreen.routeName,arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId ){});
    }
    on FirebaseAuthException catch(e){
       showSnackBar(context: context, content: e.message! );
    }
  }
  void verifyOTB({
  required BuildContext context,
    required String verificationId,
    required String userOTB,
})async{
    try{
      PhoneAuthCredential credential=PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTB,
      );
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushNamedAndRemoveUntil(
          UserInformationScreen.routeName,
              (route) => false);
    }
     on FirebaseAuthException  catch(e){
       showSnackBar(context: context, content: e.message! );
        }
  }
  saveUserDataToFirebase({
    required String name,
    required File?profilePic,
    required ProviderRef ref,
    required BuildContext context,
})async{
    try{
      String uid=auth.currentUser!.uid;
      String photoUrl=AppAssets.oTBProfileImage;
      if(profilePic != null){
       photoUrl=await ref.read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('$profilePic/$uid', profilePic);
      }
      var user=UserModel(uid: uid, name: name,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: [],
      );
     await firestore.collection(userCollection).doc(uid).set(user.toMap());
        Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(builder: (context)=>const MobileLayoutScreen()),
             (route) => false,
     );
    }
        catch(e){
      showSnackBar(context: context, content: e.toString());
        }
  }

 Stream<UserModel> userData(String userId){
    return firestore.collection(userCollection).doc(userId)
        .snapshots().map((event) => UserModel.fromMap(event.data()!));
  }
  void setUserState(bool isOnline)async{
    await firestore.collection(userCollection).doc(auth.currentUser!.uid).update({
      'isOnline':isOnline,
    });
    }
}