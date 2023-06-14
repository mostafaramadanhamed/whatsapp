import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusRepository{
final FirebaseFirestore firestore;
final FirebaseAuth auth;
final ProviderRef ref;
  StatusRepository(this.firestore, this.auth, this.ref);

}