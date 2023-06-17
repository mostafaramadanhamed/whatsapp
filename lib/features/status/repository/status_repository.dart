import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/firebasre_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/status_model.dart';
import 'package:whatsapp/models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/status/$statusId/$uid', statusImage);
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
      }
      List<String> uidWhoCanSee = [];
      for (int index = 0; index < contacts.length; index++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[index].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();
        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }
      List<String> statusImageUrls = [];
      var statusSnapShot = await firestore
          .collection('status')
          .where(
        'uid',
        isEqualTo: auth.currentUser!.uid,
      )
          .get();
      if (statusSnapShot.docs.isNotEmpty) {
        StatusModel status =
        StatusModel.fromMap(statusSnapShot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusSnapShot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }
      StatusModel status = StatusModel(
        uid: uid,
        userName: userName,
        profilePic: profilePic,
        phoneNumber: phoneNumber,
        statusId: statusId,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now() ,
        whoCanSee: uidWhoCanSee,
      );
      await firestore.collection('status').doc().set(status.toMap());
    } catch (ex) {
      //showSnackBar(context: context, content: ex.toString());
      print(ex);
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int index = 0; index < contacts.length; index++) {
        var statusSnapShot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[index].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch,
            )
            .get();
        for(var tempData in statusSnapShot.docs){
          StatusModel tempStatus=StatusModel.fromMap(tempData.data());
          if(tempStatus.whoCanSee.contains(auth.currentUser!.uid)){
            statusData.add(tempStatus);
          }
        }
      }
    } catch (ex) {
      if (kDebugMode) {
        print('$ex in get');
      }
      showSnackBar(context: context, content: ex.toString());
    }
    return statusData;
  }
}
