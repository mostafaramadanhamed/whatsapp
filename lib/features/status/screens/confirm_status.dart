import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constant/app_color.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  const ConfirmStatusScreen({
    required this.file,
    Key? key,
  }) : super(key: key);

  static const routeName='/confirm-status-screen';
 final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(aspectRatio: 9/16,child: Image.file(file),),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
