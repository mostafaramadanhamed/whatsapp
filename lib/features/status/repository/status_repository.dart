import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';

class StatusRepository{
final FirebaseFirestore firestore;
final FirebaseAuth auth;
final ProviderRef ref;
  StatusRepository({required this.firestore,required this.auth,required this.ref,});

  void updateStatus({
required String userName,
required String profilePic,
required String phoneNumber,
    required File statusImage,
    required BuildContext context,
})async{
    try{}
        catch(ex){
      showSnackBar(context: context, content: ex.toString());
        }
  }

}