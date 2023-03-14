import 'package:flutter/material.dart';
import 'package:whatsapp/utils/constant/app_assets.dart';
import 'package:whatsapp/utils/constant/app_color.dart';
import 'package:whatsapp/utils/constant/app_string.dart';
import '../../../common/widgets/custom_button.dart';
import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);


  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
  return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // todo replace 50 with 0
            // todo make screen responsive
             SizedBox(height: size.height/13,),
            Text(AppString.landingWelcome,style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.white,
            ),),
            SizedBox(
              height: size.height/9, ),
            Image.asset(
              AppAssets.landingCenterImage,
              height: size.height/2.4,
              width: size.width*0.85,
              color: tabColor,
            ),
            SizedBox(
              height: size.height/9, ),
        const Padding(
        padding: EdgeInsets.all(15.0),
        child: Text(
          AppString.landingText,
          style: TextStyle(color: greyColor),
          textAlign: TextAlign.center,
        ),
      ),
    const SizedBox(height: 10),
    SizedBox(
      width: size.width * 0.75,
      child: CustomButton(
        text: AppString.landingButton,
        onPressed: ()=>navigateToLoginScreen(context),
      ),
    ),
          ],
        ),
      ),
    );
  }
}
