import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/status/repository/status_repository.dart';
import 'package:whatsapp/models/user_model.dart';

final statusControllerProvider=Provider((ref) {
final statusRepository=ref.read(statusRepositoryProvider);
return StatusController(statusRepository: statusRepository, ref: ref);
});


class StatusController{

  final StatusRepository statusRepository;

  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });
  void addStatus(File file,BuildContext context){
    ref.watch(userDataAuthProvider).whenData((UserModel  ?value) {
      statusRepository.updateStatus(userName: value!.name,
        profilePic: value.profilePic, phoneNumber: value.phoneNumber,
        statusImage: file, context: context,
      );
    });

  }
}