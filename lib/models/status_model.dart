import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel{
  final String uid;
  final String userName;
  final String profilePic;
  final String phoneNumber;
  final String statusId;
  final List<String>photoUrl;
  final DateTime createdAt;
  final List<String>whoCanSee;

  StatusModel(
      {
        required this.uid,
      required this.userName,
      required this.profilePic,
      required this.phoneNumber,
      required this.statusId,
      required this.photoUrl,
      required this.createdAt,
      required this.whoCanSee,
      });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'statusId': statusId,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'whoCanSee': whoCanSee,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'] ??'',
      userName: map['userName'] ??'',
      profilePic: map['profilePic'] ??'',
      phoneNumber: map['phoneNumber'] ??'',
      statusId: map['statusId'] ??'',
      photoUrl:List<String>.from( map['photoUrl'] ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'],),
      //DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
      whoCanSee:List<String>.from( map['whoCanSee']),
    );
  }
}