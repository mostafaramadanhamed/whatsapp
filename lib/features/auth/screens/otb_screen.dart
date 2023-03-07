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
    final size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text( AppString.oTBAppbarTitle,),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            const SizedBox(
              height: 20,
            ),
            const Text(AppString.oTBMessage),
            SizedBox(
              width: size.width*0.5,
              child:  TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: AppString.oTBHintText,
                  hintStyle: Theme.of(context).textTheme.headline4,
                ),
                onChanged: (value){

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
