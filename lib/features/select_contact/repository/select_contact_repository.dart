import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SelectContactRepository{
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  getContacts()async{
    try{

    }
        catch(e){
      debugPrint(e.toString());
        }
  }
}