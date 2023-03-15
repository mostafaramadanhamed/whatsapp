import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/repository/auth_repository.dart';

import '../../../models/user_model.dart';

final authControllerProvider= Provider((ref) {
  final authRepository =ref.watch(authRepositoryProvider);
  return AuthController(
      authRepository: authRepository,
    ref: ref,
  );
}
);
final userDataAuthProvider=FutureProvider((ref) {
  final authController=ref.watch(authControllerProvider);
  authController.getUserData();
} );
class AuthController{
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController( {
    required this.authRepository,
    required this.ref,
  });
  Future<UserModel?>getUserData()async{
    UserModel ? user=await authRepository.getCurrentUserData();
    return user;
  }
  void signInWithPhone(BuildContext context,String phoneNumber){
      authRepository.signInWithPhone(phoneNumber, context);
  }
  void verifyOTB(BuildContext context,String userOTB, String verificationId,){
      authRepository.verifyOTB(context: context,
          verificationId: verificationId,
          userOTB: userOTB,
      );
  }

  void saveUserDataToFirebase(BuildContext context,String name, File? profilePic){
    authRepository.saveUserDataToFirebase(name: name, profilePic: profilePic, ref: ref, context: context);
  }
  Stream<UserModel>userDataById(String userId){
    return authRepository.userData(userId);
  }
  void setUserState(bool isOnline){
     authRepository.setUserState(isOnline);
  }
}