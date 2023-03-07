import 'package:flutter/material.dart';

import '../../../utils/constant/app_color.dart';
import '../../../utils/constant/app_string.dart';

class OtbScreen extends StatefulWidget {
  static const String routeName='/otb_screen';
  final String verificationId;
  const OtbScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtbScreen> createState() => _OtbScreenState();
}

class _OtbScreenState extends State<OtbScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( AppString.oTBAppbarTitle,),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),

    );
  }
}
