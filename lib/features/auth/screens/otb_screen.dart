import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import '../../../utils/constant/app_color.dart';
import '../../../utils/constant/app_string.dart';
class OtbScreen extends ConsumerWidget {
  static const String routeName='/otb_screen';
final String verificationId;
const OtbScreen({Key? key, required this.verificationId}) : super(key: key);

void verifyOTB(BuildContext context, String userOTB,WidgetRef ref){
 ref.read(authControllerProvider).verifyOTB(context, userOTB, verificationId);
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  if(value.length==6){
                    verifyOTB(context, value.trim(), ref);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
