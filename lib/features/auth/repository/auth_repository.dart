import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/screens/otb_screen.dart';

class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

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
}